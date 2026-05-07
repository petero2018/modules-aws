import json
import logging
import os

import boto3
import urllib3

# Logging
logger = logging.getLogger()
logger.setLevel(os.environ.get("LOG_LEVEL", "INFO"))

# From https://developers.google.com/search/docs/crawling-indexing/verifying-googlebot
GOOGLE_BOT_URL = (
    "https://developers.google.com/static/search/apis/ipranges/googlebot.json"
)
GOOGLE_SPECIAL_CASE_URL = (
    "https://developers.google.com/static/search/apis/ipranges/special-crawlers.json"
)
GOOGLE_USER_TRIGGERED_URL = "https://developers.google.com/static/search/apis/ipranges/user-triggered-fetchers.json"

BING_URL = "https://www.bing.com/toolbox/bingbot.json"


ipset_regional_ipv4_id = os.environ.get("IPV4_REGIONAL_IPSET_ID")
ipset_regional_ipv6_id = os.environ.get("IPV6_REGIONAL_IPSET_ID")
ipset_regional_ipv4_name = os.environ.get("IPV4_REGIONAL_IPSET_NAME")
ipset_regional_ipv6_name = os.environ.get("IPV6_REGIONAL_IPSET_NAME")

ipset_cloudfront_ipv4_id = os.environ.get("IPV4_CLOUDFRONT_IPSET_ID")
ipset_cloudfront_ipv6_id = os.environ.get("IPV6_CLOUDFRONT_IPSET_ID")
ipset_cloudfront_ipv4_name = os.environ.get("IPV4_CLOUDFRONT_IPSET_NAME")
ipset_cloudfront_ipv6_name = os.environ.get("IPV6_CLOUDFRONT_IPSET_NAME")

aws_region = os.environ.get("AWS_REGION", "us-east-1")

session = boto3.session.Session()
http = urllib3.PoolManager()


def update_list_ips(ipset_name, ipset_id, scope, addresses, region):
    client = session.client("wafv2", region_name=region)

    response = client.get_ip_set(Name=ipset_name, Scope=scope, Id=ipset_id)

    status = response["ResponseMetadata"]["HTTPStatusCode"]

    if status != 200:
        logger.error(f"ERROR: update_list_ips {response}")
        return response

    description = response["IPSet"]["Description"]
    token = response["LockToken"]

    response = client.update_ip_set(
        Name=ipset_name,
        Description=description,
        Scope=scope,
        Id=ipset_id,
        Addresses=addresses,
        LockToken=token,
    )

    status = response["ResponseMetadata"]["HTTPStatusCode"]
    logger.info(
        f"Updated ip set with {len(addresses)} ranges in scope {scope} with id {ipset_id} and name {ipset_name} with status {status}"
    )

    return response


def get_ips(url):
    headers = {"Content-Type": "application/json"}

    response = http.request("GET", url, headers=headers)

    json_data = json.loads(response.data)

    ips_ipv4 = []
    ips_ipv6 = []

    for d in json_data["prefixes"]:
        if "ipv4Prefix" in d:
            ips_ipv4.append(d["ipv4Prefix"])
        elif "ipv6Prefix" in d:
            ips_ipv6.append(d["ipv6Prefix"])

    return (ips_ipv4, ips_ipv6)


def lambda_handler(event, context):
    google_bot_ips_v4, google_bot_ips_v6 = get_ips(GOOGLE_BOT_URL)
    google_special_ips_v4, google_special_ips_v6 = get_ips(GOOGLE_SPECIAL_CASE_URL)
    google_user_triggered_ips_v4, google_user_triggered_ips_v6 = get_ips(
        GOOGLE_USER_TRIGGERED_URL
    )
    bing_ips_v4, bing_ips_v6 = get_ips(BING_URL)

    ipv4_ips = (
        google_bot_ips_v4
        + google_special_ips_v4
        + google_user_triggered_ips_v4
        + bing_ips_v4
    )
    ipv6_ips = (
        google_bot_ips_v6
        + google_special_ips_v6
        + google_user_triggered_ips_v6
        + bing_ips_v6
    )

    # Regional
    if ipset_regional_ipv4_id:
        update_list_ips(
            ipset_regional_ipv4_name,
            ipset_regional_ipv4_id,
            "REGIONAL",
            ipv4_ips,
            aws_region,
        )
    if ipset_regional_ipv6_id:
        update_list_ips(
            ipset_regional_ipv6_name,
            ipset_regional_ipv6_id,
            "REGIONAL",
            ipv6_ips,
            aws_region,
        )

    # Cloudfront (must be done using the us-east-1 region)
    if ipset_cloudfront_ipv4_id:
        update_list_ips(
            ipset_cloudfront_ipv4_name,
            ipset_cloudfront_ipv4_id,
            "CLOUDFRONT",
            ipv4_ips,
            "us-east-1",
        )
    if ipset_cloudfront_ipv6_id:
        update_list_ips(
            ipset_cloudfront_ipv6_name,
            ipset_cloudfront_ipv6_id,
            "CLOUDFRONT",
            ipv6_ips,
            "us-east-1",
        )
