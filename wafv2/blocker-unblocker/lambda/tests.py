#!/usr/bin/env python3

import json
import logging
import time
import unittest
from unittest.mock import ANY, MagicMock, patch, call
import moto
import os

import boto3

import common.ipset
import common.dynamodb
from blocker.lambda_function import lambda_handler as blocker_handler
from updater.lambda_function import lambda_handler as updater_handler


# Set up logging
logger = logging.getLogger()
logging.basicConfig(level=logging.WARNING)


@moto.mock_wafv2
@moto.mock_dynamodb
class WAFBlockerUnblockerTestCase(unittest.TestCase):
    def setUp(self):
        self.block_test_table_name = "BlockTestTable"
        self.allow_test_table_name = "AllowTestTable"
        self.gsi_name = "IPVersionExpirationIndex"

        self.allow_ipset_ipv4 = ",".join(
            [
                "arn:aws:wafv2:us-east-1:123456789012:global/ipset/allow_ipv4_global/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
                "arn:aws:wafv2:us-east-1:123456789012:regional/ipset/allow_ipv4_use1/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
                "arn:aws:wafv2:eu-west-1:123456789012:regional/ipset/allow_ipv4_ew1/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
            ]
        )

        self.allow_ipset_ipv6 = ",".join(
            [
                "arn:aws:wafv2:us-east-1:123456789012:global/ipset/allow_ipv6_global/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
                "arn:aws:wafv2:us-east-1:123456789012:regional/ipset/allow_ipv6_use1/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
                "arn:aws:wafv2:eu-west-1:123456789012:regional/ipset/allow_ipv6_ew1/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
            ]
        )

        self.block_ipset_ipv4 = ",".join(
            [
                "arn:aws:wafv2:us-east-1:123456789012:global/ipset/block_ipv4_global/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
                "arn:aws:wafv2:us-east-1:123456789012:regional/ipset/block_ipv4_use1/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
                "arn:aws:wafv2:eu-west-1:123456789012:regional/ipset/block_ipv4_ew1/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
            ]
        )

        self.block_ipset_ipv6 = ",".join(
            [
                "arn:aws:wafv2:us-east-1:123456789012:global/ipset/block_ipv6_global/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
                "arn:aws:wafv2:us-east-1:123456789012:regional/ipset/block_ipv6_use1/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
                "arn:aws:wafv2:eu-west-1:123456789012:regional/ipset/block_ipv6_ew1/01234567-89ab-cdef-0123-456789abcdef",  # noqa E501
            ]
        )

        os.environ["DYNAMODB_WHITELIST_TABLE_NAME"] = self.allow_test_table_name
        os.environ["DYNAMODB_BLOCKS_TABLE_NAME"] = self.block_test_table_name
        os.environ["DYNAMODB_WHITELIST_INDEX_NAME"] = self.gsi_name
        os.environ["DYNAMODB_BLOCKS_INDEX_NAME"] = self.gsi_name

        os.environ["ALLOW_IPSET_ARNS_IPV4"] = self.allow_ipset_ipv4
        os.environ["BLOCK_IPSET_ARNS_IPV4"] = self.block_ipset_ipv4
        os.environ["ALLOW_IPSET_ARNS_IPV6"] = self.allow_ipset_ipv6
        os.environ["BLOCK_IPSET_ARNS_IPV6"] = self.block_ipset_ipv6

        dynamodb = boto3.resource("dynamodb")
        dynamodb.create_table(
            TableName=self.block_test_table_name,
            KeySchema=[{"AttributeName": "IP", "KeyType": "HASH"}],
            AttributeDefinitions=[
                {"AttributeName": "IP", "AttributeType": "S"},
                {"AttributeName": "IPVersion", "AttributeType": "S"},
                {"AttributeName": "timestamp_expired", "AttributeType": "N"},
            ],
            BillingMode="PAY_PER_REQUEST",
            GlobalSecondaryIndexes=[
                {
                    "IndexName": self.gsi_name,
                    "KeySchema": [
                        {"AttributeName": "IPVersion", "KeyType": "HASH"},
                        {"AttributeName": "timestamp_expired", "KeyType": "RANGE"},
                    ],
                    "Projection": {"ProjectionType": "ALL"},
                }
            ],
        )
        dynamodb.create_table(
            TableName=self.allow_test_table_name,
            KeySchema=[{"AttributeName": "IP", "KeyType": "HASH"}],
            AttributeDefinitions=[
                {"AttributeName": "IP", "AttributeType": "S"},
                {"AttributeName": "IPVersion", "AttributeType": "S"},
                {"AttributeName": "timestamp_expired", "AttributeType": "N"},
            ],
            BillingMode="PAY_PER_REQUEST",
            GlobalSecondaryIndexes=[
                {
                    "IndexName": self.gsi_name,
                    "KeySchema": [
                        {"AttributeName": "IPVersion", "KeyType": "HASH"},
                        {"AttributeName": "timestamp_expired", "KeyType": "RANGE"},
                    ],
                    "Projection": {"ProjectionType": "ALL"},
                }
            ],
        )

        mocked_dynamodb_client = boto3.client("dynamodb")
        mocked_session = boto3.session.Session()

        mocked_dynamodb_config = {
            "client": mocked_dynamodb_client,
            "block_table_name": self.block_test_table_name,
            "allow_table_name": self.allow_test_table_name,
            "block_index_name": self.gsi_name,
            "allow_index_name": self.gsi_name,
        }
        mocked_wafv2_config = {
            "wafv2_session": mocked_session,
            "allow_ipsets_ipv4": self.allow_ipset_ipv4,
            "allow_ipsets_ipv6": self.allow_ipset_ipv6,
            "block_ipsets_ipv4": self.block_ipset_ipv4,
            "block_ipsets_ipv6": self.block_ipset_ipv6,
        }

        self.mocked_dynamodb_config = common.dynamodb.DynamoDBConfig(
            mocked_dynamodb_config
        )
        self.mocked_wafv2_config = common.ipset.WAFv2Config(mocked_wafv2_config)

    def tearDown(self):
        dynamodb = boto3.client("dynamodb", region_name="us-east-1")
        dynamodb.delete_table(TableName=self.block_test_table_name)
        dynamodb.delete_table(TableName=self.allow_test_table_name)

    ###########################################################################
    # Helper functions
    ###########################################################################

    def _block_ip(self, ip, ip_version, expiration_timestamp):
        self.mocked_dynamodb_config.dynamodb.put_item(
            TableName=self.block_test_table_name,
            Item={
                "IP": {"S": ip},
                "IPVersion": {"S": ip_version},
                "timestamp": {"N": str(int(time.time()))},
                "timestamp_expired": {"N": str(expiration_timestamp)},
            },
        )

    def _allow_ip(self, ip, ip_version, expiration_timestamp, from_timestamp):
        self.mocked_dynamodb_config.dynamodb.put_item(
            TableName=self.allow_test_table_name,
            Item={
                "IP": {"S": ip},
                "IPVersion": {"S": ip_version},
                "timestamp_expired": {"N": str(expiration_timestamp)},
                "timestamp_from": {"N": str(from_timestamp)},
            },
        )

    ###########################################################################
    # Test DynamoDB
    ###########################################################################

    def test_get_blocked_ips(self):
        self._block_ip("1.1.1.1", "v4", int(time.time()) + 300)

        self.assertListEqual(
            common.dynamodb.get_blocked_ips("v4", self.mocked_dynamodb_config),
            ["1.1.1.1"],
        )

    def test_get_blocked_ips_excludes_expired(self):
        self._block_ip("1.1.1.1", "v4", int(time.time()) - 300)
        self._block_ip("2.2.2.2", "v4", int(time.time()) + 300)

        self.assertListEqual(
            ["2.2.2.2"],
            common.dynamodb.get_blocked_ips("v4", self.mocked_dynamodb_config),
        )

    def test_get_allowed_ips(self):
        self._allow_ip(
            "1.1.1.1",
            "v4",
            from_timestamp=int(time.time()) - 300,
            expiration_timestamp=int(time.time()) + 300,
        )

        self.assertListEqual(
            ["1.1.1.1"],
            common.dynamodb.get_allowed_ips("v4", self.mocked_dynamodb_config),
        )

    def test_get_allowed_ips_excludes_expired(self):
        self._allow_ip(
            "1.1.1.1",
            "v4",
            from_timestamp=int(time.time()) - 300,
            expiration_timestamp=int(time.time()) - 200,
        )
        self._allow_ip(
            "2.2.2.2",
            "v4",
            from_timestamp=int(time.time()) - 300,
            expiration_timestamp=int(time.time()) + 300,
        )

        self.assertListEqual(
            ["2.2.2.2"],
            common.dynamodb.get_allowed_ips("v4", self.mocked_dynamodb_config),
        )

    def test_get_allowed_ips_excludes_future_ips(self):
        self._allow_ip(
            "1.1.1.1",
            "v4",
            from_timestamp=int(time.time()) + 300,
            expiration_timestamp=int(time.time()) + 600,
        )

        self.assertListEqual(
            [],
            common.dynamodb.get_allowed_ips("v4", self.mocked_dynamodb_config),
        )

    def test_dynamodb_block(self):
        common.dynamodb.dynamodb_block(
            "1.1.1.1", "v4", 300, self.mocked_dynamodb_config
        )

        expected_item = {
            "IP": {"S": "1.1.1.1"},
            "IPVersion": {"S": "v4"},
            "timestamp": {"N": str(int(time.time()))},
            "timestamp_expired": {"N": str(int(time.time()) + 300)},
        }

        self.assertEqual(
            expected_item,
            self.mocked_dynamodb_config.dynamodb.get_item(
                TableName=self.block_test_table_name, Key={"IP": {"S": "1.1.1.1"}}
            )["Item"],
        )

    def test_is_whitelisted(self):
        self._allow_ip(
            "1.1.1.1",
            "v4",
            from_timestamp=int(time.time()) - 300,
            expiration_timestamp=int(time.time()) + 300,
        )

        self.assertTrue(
            common.dynamodb.is_whitelisted("1.1.1.1", self.mocked_dynamodb_config)
        )

    def test_is_whitelisted_ipv6(self):
        self._allow_ip(
            "2001:0db8:85a3:0000:0000:8a2e:0370:7334",
            "v6",
            from_timestamp=int(time.time()) - 300,
            expiration_timestamp=int(time.time()) + 300,
        )

        self.assertTrue(
            common.dynamodb.is_whitelisted(
                "2001:0db8:85a3:0000:0000:8a2e:0370:7334", self.mocked_dynamodb_config
            )
        )

    def test_is_whitelisted_excludes_expired(self):
        self._allow_ip(
            "1.1.1.1",
            "v4",
            from_timestamp=int(time.time()) - 300,
            expiration_timestamp=int(time.time()) - 200,
        )

        self.assertFalse(
            common.dynamodb.is_whitelisted("1.1.1.1", self.mocked_dynamodb_config)
        )

    def test_is_whitelisted_excludes_future_ips(self):
        self._allow_ip(
            "1.1.1.1",
            "v4",
            from_timestamp=int(time.time()) + 300,
            expiration_timestamp=int(time.time()) + 600,
        )

        self.assertFalse(
            common.dynamodb.is_whitelisted("1.1.1.1", self.mocked_dynamodb_config)
        )

    ###########################################################################
    # Test IPSet
    ###########################################################################

    def test_to_cidr(self):
        ips = ["1.1.1.1", "2.2.2.2/32", "3.3.3.0/24"]

        self.assertListEqual(
            common.ipset.to_cidr(ips), ["1.1.1.1/32", "2.2.2.2/32", "3.3.3.0/24"]
        )

    def test_convert_arn_scope(self):
        with self.subTest():
            self.assertEqual("REGIONAL", common.ipset.convert_arn_scope("regional"))
            self.assertEqual("CLOUDFRONT", common.ipset.convert_arn_scope("global"))
            self.assertRaises(ValueError, common.ipset.convert_arn_scope, "invalid")

    def test_ipset_from_arn(self):
        arn = "arn:aws:wafv2:us-east-1:012345678901:global/ipset/bad_ips/01234567-89ab-cdef-0123-456789abcdef"

        ipset = common.ipset.ipset_from_arn(arn, self.mocked_wafv2_config.wafv2_session)

        with self.subTest():
            self.assertEqual(ipset.arn, arn)
            self.assertEqual(ipset.scope, "CLOUDFRONT")
            self.assertEqual(ipset.name, "bad_ips")
            self.assertEqual(ipset.region, "us-east-1")
            self.assertEqual(ipset.uid, "01234567-89ab-cdef-0123-456789abcdef")

    def test_extract_ipsets(self):
        extracted_ipsets = common.ipset.extract_ipsets(
            self.allow_ipset_ipv4, self.mocked_wafv2_config.wafv2_session
        )

        with self.subTest():
            for ipset in extracted_ipsets:
                self.assertIsInstance(ipset, common.ipset.IPSet)

    def test_extract_ipsets_empty(self):
        self.assertRaises(
            ValueError,
            common.ipset.extract_ipsets,
            "",
            self.mocked_wafv2_config.wafv2_session,
        )

    ###########################################################################
    # Test Lambda Handlers
    ###########################################################################

    def load_sample_event_from_file(self, filename: str):
        test_event_file = f"./sample_events/{filename}.json"
        with open(test_event_file, "r") as f:
            return json.load(f)

    # Blocker

    @patch("blocker.lambda_function.DynamoDBConfig")
    @patch("blocker.lambda_function.is_whitelisted")
    @patch("blocker.lambda_function.dynamodb_block")
    def test_lambda_handler_blocker_ok(
        self,
        patch_dynamodb_block: MagicMock,
        patch_is_whitelisted: MagicMock,
        patch_dynamodb_config: MagicMock,
    ):
        patch_dynamodb_block.return_value = None
        patch_is_whitelisted.return_value = False
        patch_dynamodb_config.return_value = self.mocked_dynamodb_config

        test_event = self.load_sample_event_from_file("blockOK")
        test_return_value = blocker_handler(event=test_event, context=None)

        ip, version, expiration = "1.1.1.1", "v4", 300

        return_value = {
            "result": "ok",
            "message": ANY,
        }

        patch_dynamodb_block.assert_called_once_with(
            ip=ip,
            ip_version=version,
            duration_seconds=expiration,
            config=self.mocked_dynamodb_config,
        )

        patch_is_whitelisted.assert_called_once_with(
            ip=ip, config=self.mocked_dynamodb_config
        )

        self.assertEqual(test_return_value, return_value)

    @patch("blocker.lambda_function.DynamoDBConfig")
    @patch("blocker.lambda_function.is_whitelisted")
    @patch("blocker.lambda_function.dynamodb_block")
    def test_lambda_handler_blocker_whitelisted(
        self,
        patch_dynamodb_block: MagicMock,
        patch_is_whitelisted: MagicMock,
        patch_dynamodb_config: MagicMock,
    ):
        patch_dynamodb_block.return_value = None
        patch_is_whitelisted.return_value = True
        patch_dynamodb_config.return_value = self.mocked_dynamodb_config

        test_event = self.load_sample_event_from_file("blockWhitelisted")
        test_return_value = blocker_handler(event=test_event, context=None)

        ip = "1.1.1.1"

        return_value = {
            "result": "ok",
            "message": ANY,
        }

        patch_is_whitelisted.assert_called_once_with(
            ip=ip, config=self.mocked_dynamodb_config
        )
        patch_dynamodb_block.assert_not_called()

        self.assertEqual(test_return_value, return_value)

    @patch("blocker.lambda_function.DynamoDBConfig")
    @patch("blocker.lambda_function.is_whitelisted")
    @patch("blocker.lambda_function.dynamodb_block")
    def test_lambda_handler_blocker_timestamp_not_duration(
        self,
        patch_dynamodb_block: MagicMock,
        patch_is_whitelisted: MagicMock,
        patch_dynamodb_config: MagicMock,
    ):
        patch_dynamodb_block.return_value = None
        patch_is_whitelisted.return_value = False
        patch_dynamodb_config.return_value = self.mocked_dynamodb_config

        test_event = self.load_sample_event_from_file("blockTimestamp")
        test_return_value = blocker_handler(event=test_event, context=None)

        ip, version, expiration = "1.1.1.1", "v4", 2 * 60 * 60

        return_value = {
            "result": "ok",
            "message": ANY,
        }

        patch_is_whitelisted.assert_called_once_with(
            ip=ip, config=self.mocked_dynamodb_config
        )
        patch_dynamodb_block.assert_called_once_with(
            ip=ip,
            ip_version=version,
            duration_seconds=expiration,
            config=self.mocked_dynamodb_config,
        )

        self.assertEqual(test_return_value, return_value)

    @patch("blocker.lambda_function.DynamoDBConfig")
    @patch("blocker.lambda_function.is_whitelisted")
    @patch("blocker.lambda_function.dynamodb_block")
    def test_lambda_handler_blocker_invalid(
        self,
        patch_dynamodb_block: MagicMock,
        patch_is_whitelisted: MagicMock,
        patch_dynamodb_config: MagicMock,
    ):
        patch_dynamodb_block.return_value = None
        patch_is_whitelisted.return_value = False
        patch_dynamodb_config.return_value = self.mocked_dynamodb_config

        test_event = self.load_sample_event_from_file("blockInvalid")
        test_return_value = blocker_handler(event=test_event, context=None)

        return_value = {
            "result": "error",
            "message": ANY,
        }

        patch_is_whitelisted.assert_not_called()
        patch_dynamodb_block.assert_not_called()

        self.assertEqual(test_return_value, return_value)

    # Updater

    # TODO: This only tests the full case - where all 4 ipsets have 1 element
    @patch("common.ipset.IPSet.set")
    @patch("updater.lambda_function.get_allowed_ips")
    @patch("updater.lambda_function.get_blocked_ips")
    @patch("updater.lambda_function.extract_ipsets")
    @patch("updater.lambda_function.WAFv2Config")
    @patch("updater.lambda_function.DynamoDBConfig")
    def test_lambda_handler_updater_ok(
        self,
        patch_dynamodb_config: MagicMock,
        patch_wafv2_config: MagicMock,
        patch_extract_ipsets: MagicMock,
        patch_get_blocked_ips: MagicMock,
        patch_get_allowed_ips: MagicMock,
        patch_ipset_set: MagicMock,
    ):
        patch_dynamodb_config.return_value = self.mocked_dynamodb_config
        patch_wafv2_config.return_value = self.mocked_wafv2_config
        patch_extract_ipsets.return_value = [
            common.ipset.ipset_from_arn(arn, self.mocked_wafv2_config.wafv2_session)
            for arn in self.allow_ipset_ipv4.split(",")
        ]
        patch_get_blocked_ips.return_value = ["1.1.1.1", "2.2.2.2"]
        patch_get_allowed_ips.return_value = ["3.3.3.3", "4.4.4.4"]
        patch_ipset_set.return_value = None

        updater_handler(event=None, context=None)

        patch_extract_ipsets.assert_has_calls(
            [
                call(self.block_ipset_ipv4, self.mocked_wafv2_config.wafv2_session),
                call(self.block_ipset_ipv6, self.mocked_wafv2_config.wafv2_session),
                call(self.allow_ipset_ipv4, self.mocked_wafv2_config.wafv2_session),
                call(self.allow_ipset_ipv6, self.mocked_wafv2_config.wafv2_session),
            ],
            any_order=True,
        )

        patch_get_blocked_ips.assert_has_calls(
            [
                call("v4", self.mocked_dynamodb_config),
                call("v6", self.mocked_dynamodb_config),
            ],
            any_order=True,
        )
        patch_get_allowed_ips.assert_has_calls(
            [
                call("v4", self.mocked_dynamodb_config),
                call("v6", self.mocked_dynamodb_config),
            ],
            any_order=True,
        )

        patch_ipset_set.assert_has_calls(
            [call(ANY)] * patch_extract_ipsets.call_count, any_order=True
        )
