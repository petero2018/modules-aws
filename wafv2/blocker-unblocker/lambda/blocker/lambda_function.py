try:
    from common.dynamodb import is_whitelisted, dynamodb_block, DynamoDBConfig
except ImportError:  # pragma: no cover
    from dynamodb import is_whitelisted, dynamodb_block, DynamoDBConfig

import logging
import os
import boto3


logger = logging.getLogger()
logger.setLevel(os.environ.get("LOG_LEVEL", "INFO"))


_DYNAMODB_CONFIG = {
    "client": boto3.client("dynamodb"),
    "allow_table_name": os.environ.get("DYNAMODB_WHITELIST_TABLE_NAME"),
    "block_table_name": os.environ.get("DYNAMODB_BLOCKS_TABLE_NAME"),
    "allow_index_name": os.environ.get("DYNAMODB_WHITELIST_INDEX_NAME"),
    "block_index_name": os.environ.get("DYNAMODB_BLOCKS_INDEX_NAME"),
}


def lambda_handler(event, context):
    global _DYNAMODB_CONFIG

    dynamodb_config = DynamoDBConfig(_DYNAMODB_CONFIG)

    try:
        ip, ip_version, timestamp = event["Records"][0]["Sns"]["Message"].split(",")
    except ValueError:
        return {"result": "error", "message": "Invalid event format"}

    try:
        expired_in_seconds = int(timestamp)
    except ValueError:
        expired_in_seconds = 2 * 60 * 60  # 2 hours by default

    logger.info(f"ip={ip} expired_in_seconds={expired_in_seconds}")

    if is_whitelisted(ip=ip, config=dynamodb_config):
        return {"result": "ok", "message": f"{ip} is in whitelist, skipping block"}

    # Insert IP into DynamoDB
    dynamodb_block(
        ip=ip,
        ip_version=ip_version,
        duration_seconds=expired_in_seconds,
        config=dynamodb_config,
    )

    return {
        "result": "ok",
        "message": f"{ip} blocked for {expired_in_seconds} seconds",
    }
