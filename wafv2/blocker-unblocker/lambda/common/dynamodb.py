import time
import logging
import ipaddress

logger = logging.getLogger(__name__)


class DynamoDBConfig:
    def __init__(self, cfg):
        self.dynamodb = cfg["client"]
        self.block_table_name = cfg["block_table_name"]
        self.allow_table_name = cfg["allow_table_name"]
        self.block_index_name = cfg["block_index_name"]
        self.allow_index_name = cfg["allow_index_name"]


def get_blocked_ips(ip_version: str, config: DynamoDBConfig):
    timestamp = int(time.time())
    ips = (
        config.dynamodb.get_paginator("query")
        .paginate(
            TableName=config.block_table_name,
            IndexName=config.block_index_name,
            KeyConditionExpression="IPVersion = :ipv AND timestamp_expired > :t",  # gitleaks:allow
            ExpressionAttributeValues={
                ":ipv": {"S": ip_version},
                ":t": {"N": str(timestamp)},
            },
        )
        .build_full_result()
    )

    logger.debug(f"Found {len(ips['Items'])} non-expired {ip_version} IPs in DynamoDB")

    return [item["IP"]["S"] for item in ips["Items"]]


def get_allowed_ips(ip_version: str, config: DynamoDBConfig):
    timestamp = int(time.time())
    ips = (
        config.dynamodb.get_paginator("query")
        .paginate(
            TableName=config.allow_table_name,
            IndexName=config.allow_index_name,
            KeyConditionExpression="IPVersion = :ipv AND timestamp_expired > :t",  # gitleaks:allow
            FilterExpression="timestamp_from <= :t",
            ExpressionAttributeValues={
                ":ipv": {"S": ip_version},
                ":t": {"N": str(timestamp)},
            },
        )
        .build_full_result()
    )

    logger.debug(f"Found {len(ips['Items'])} allowed {ip_version} IPs in DynamoDB")

    return [item["IP"]["S"] for item in ips["Items"]]


def dynamodb_block(
    ip: str, ip_version: str, duration_seconds: int, config: DynamoDBConfig
):
    timestamp = int(time.time())
    response = config.dynamodb.put_item(
        TableName=config.block_table_name,
        Item={
            "IP": {"S": ip},
            "IPVersion": {"S": ip_version},
            "timestamp": {"N": str(timestamp)},
            "timestamp_expired": {"N": str(timestamp + duration_seconds)},
        },
    )
    return response


def is_whitelisted(ip, config: DynamoDBConfig):
    if ipaddress.ip_address(ip).version == 6:
        response = get_allowed_ips(ip_version="v6", config=config)
    else:
        response = get_allowed_ips(ip_version="v4", config=config)

    return ip in response
