import logging
import os
import boto3

try:
    from common.dynamodb import get_blocked_ips, get_allowed_ips, DynamoDBConfig
    from common.ipset import extract_ipsets, WAFv2Config
except ImportError:  # pragma: no cover
    from dynamodb import get_blocked_ips, get_allowed_ips, DynamoDBConfig
    from ipset import extract_ipsets, WAFv2Config

logger = logging.getLogger()
logger.setLevel(os.environ.get("LOG_LEVEL", "INFO"))


_DYNAMODB_CONFIG = {
    "client": boto3.client("dynamodb"),
    "allow_table_name": os.environ.get("DYNAMODB_WHITELIST_TABLE_NAME"),
    "block_table_name": os.environ.get("DYNAMODB_BLOCKS_TABLE_NAME"),
    "allow_index_name": os.environ.get("DYNAMODB_WHITELIST_INDEX_NAME"),
    "block_index_name": os.environ.get("DYNAMODB_BLOCKS_INDEX_NAME"),
}


_WAFV2_CONFIG = {
    "wafv2_session": boto3.session.Session(),
    "allow_ipsets_ipv4": os.environ.get("ALLOW_IPSET_ARNS_IPV4", ""),
    "allow_ipsets_ipv6": os.environ.get("ALLOW_IPSET_ARNS_IPV6", ""),
    "block_ipsets_ipv4": os.environ.get("BLOCK_IPSET_ARNS_IPV4", ""),
    "block_ipsets_ipv6": os.environ.get("BLOCK_IPSET_ARNS_IPV6", ""),
}


def lambda_handler(event, context):
    global _DYNAMODB_CONFIG
    global _WAFV2_CONFIG

    dynamodb_config = DynamoDBConfig(_DYNAMODB_CONFIG)
    wafv2_config = WAFv2Config(_WAFV2_CONFIG)

    allow_ipsets_ipv4 = extract_ipsets(
        wafv2_config.allow_ipsets_ipv4, wafv2_config.wafv2_session
    )
    allow_ipsets_ipv6 = extract_ipsets(
        wafv2_config.allow_ipsets_ipv6, wafv2_config.wafv2_session
    )
    block_ipsets_ipv4 = extract_ipsets(
        wafv2_config.block_ipsets_ipv4, wafv2_config.wafv2_session
    )
    block_ipsets_ipv6 = extract_ipsets(
        wafv2_config.block_ipsets_ipv6, wafv2_config.wafv2_session
    )

    blocked_ips_ipv4 = get_blocked_ips("v4", dynamodb_config)
    blocked_ips_ipv6 = get_blocked_ips("v6", dynamodb_config)

    allowed_ips_ipv4 = get_allowed_ips("v4", dynamodb_config)
    allowed_ips_ipv6 = get_allowed_ips("v6", dynamodb_config)

    # Sync WAF IP sets with updated DynamoDB data
    for ipset in block_ipsets_ipv4:
        logger.info(f"Block: IPv4: Updating WAF IP set {ipset.arn}")
        ipset.set(blocked_ips_ipv4)

    for ipset in block_ipsets_ipv6:
        logger.info(f"Block: IPv6: Updating WAF IP set {ipset.arn}")
        ipset.set(blocked_ips_ipv6)

    for ipset in allow_ipsets_ipv4:
        logger.info(f"Allow: IPv4: Updating WAF IP set {ipset.arn}")
        ipset.set(allowed_ips_ipv4)

    for ipset in allow_ipsets_ipv6:
        logger.info(f"Allow: IPv6: Updating WAF IP set {ipset.arn}")
        ipset.set(allowed_ips_ipv6)
