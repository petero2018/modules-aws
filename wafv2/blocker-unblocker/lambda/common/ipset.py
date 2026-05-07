from dataclasses import dataclass, field
import botocore
import ipaddress
import time
import logging
import boto3


logger = logging.getLogger(__name__)


class WAFv2Config:
    def __init__(self, cfg):
        self.wafv2_session = cfg["wafv2_session"]
        self.allow_ipsets_ipv4 = cfg["allow_ipsets_ipv4"]
        self.allow_ipsets_ipv6 = cfg["allow_ipsets_ipv6"]
        self.block_ipsets_ipv4 = cfg["block_ipsets_ipv4"]
        self.block_ipsets_ipv6 = cfg["block_ipsets_ipv6"]


@dataclass
class IPSet:
    region: str
    scope: str
    name: str
    uid: str  # Only because 'id' behaves differently in syntax highlighting
    arn: str  # Mostly for logging purposes
    client: "botocore.client.WAFV2"  # Useful shortcut
    lock_token: str = field(default=None, init=False)  # Fetched dynamically
    description: str = field(default=None, init=False)  # Fetched dynamically

    def _handle_lock(func, max_attempts=30, backoff_base=1.15):
        """
        This function is a decorator to handle WAFOptimisticLockException when updating WAF IP Sets.
        It will try again up to a maximum number of attemps, refreshing the token each time.
        Handling this token prevents from having race conditions with multiple concurrent updates.
        """

        def wrapper(self, *args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return func(self, *args, **kwargs)
                except self.client.exceptions.WAFOptimisticLockException:
                    logger.warning(
                        f"WAFOptimisticLockException on {func.__name__} for {self.arn}, retrying... ({attempt + 1}/{max_attempts})"  # noqa: E501
                    )
                    self.lock_token = None
                    time.sleep(backoff_base**attempt)  # Exponential backoff
            raise Exception(
                f"Maximum retries exceeded when attempting to update IPSet {self.arn}"
            )

        return wrapper

    def get(self):
        response = self.client.get_ip_set(
            Name=self.name,
            Scope=self.scope,
            Id=self.uid,
        )
        self.lock_token = response["LockToken"]
        self.description = response["IPSet"]["Description"]
        self.ip_version = response["IPSet"]["IPAddressVersion"]
        return response

    def get_addresses(self):
        return self.get()["IPSet"]["Addresses"]

    def attempt_set(self, addresses):
        args = {
            "Name": self.name,
            "Scope": self.scope,
            "Id": self.uid,
            "Addresses": addresses,
            "LockToken": self.lock_token,
        }

        # Add description if it exists
        if self.description:
            args["Description"] = self.description

        response = self.client.update_ip_set(**args)
        self.lock_token = response["NextLockToken"]
        return response

    @_handle_lock
    def set(self, addresses):
        if not self.lock_token:
            self.get()
        return self.attempt_set(to_cidr(addresses))


# IP set ARN has 'global' or 'regional' scope instead of 'CLOUDFRONT' or 'REGIONAL'
def convert_arn_scope(scope):
    if scope == "regional":
        return "REGIONAL"
    elif scope == "global":
        return "CLOUDFRONT"
    else:
        raise ValueError(f"Invalid ARN scope: '{scope}'")


def ipset_from_arn(ipset_arn: str, session: boto3.Session) -> IPSet:
    # ARN example: arn:aws:wafv2:us-east-1:012345678901:global/ipset/bad_ips/01234567-89ab-cdef-0123-456789abcdef
    arn_split = ipset_arn.split(":")
    aws_region = arn_split[3]
    ipset_split = arn_split[5].split("/")
    client = session.client(
        "wafv2",
        region_name=aws_region,
        config=botocore.config.Config(retries=dict(max_attempts=10)),
    )

    return IPSet(
        arn=ipset_arn,
        region=aws_region,
        scope=convert_arn_scope(ipset_split[0]),
        name=ipset_split[2],
        uid=ipset_split[3],
        client=client,
    )


# This extracts IP sets info from a comma-separated list of IP set ARNs
def extract_ipsets(ipsets_string: str, session: boto3.Session) -> list[IPSet]:
    ipsets = []
    ipset_arns = ipsets_string.split(",")  # ARNs are comma-separated
    if len(ipset_arns) == 0 or ipset_arns[0] == "":
        raise ValueError("Could not create a list of IPSet ARNs")
    # Extract IP sets information
    for ipset_arn in ipset_arns:
        ipsets.append(ipset_from_arn(ipset_arn.strip(), session))
    return ipsets


def to_cidr(addresses: list[str]) -> list[str]:
    return [str(ipaddress.ip_network(ip)) for ip in addresses]
