# RDS snapshots cannot be copied cross-account & cross-region at the same time
# To solve this issue we can first copy cross-region then cross-acount, or the other way around
# Code inspired from https://github.com/aws-samples/aws-blog-automate-amazon-rds-cross-account-backups/blob/main/account_b_region_a.yml
# Original article: https://aws.amazon.com/blogs/database/automate-cross-account-backups-of-amazon-rds-and-amazon-aurora-databases-with-aws-backup/

import logging
import json
import os

import boto3

# Logging configuration
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
logging.getLogger('boto3').setLevel(logging.WARNING)
logging.getLogger('botocore').setLevel(logging.WARNING)

# Environment variables
IAM_BACKUP_ROLE_ARN = os.environ.get('IAM_BACKUP_ROLE_ARN')
DESTINATION_BACKUP_VAULT_ARN = os.environ.get('DESTINATION_BACKUP_VAULT_ARN')
BACKUP_REGION = os.environ.get('BACKUP_REGION')
BACKUP_RETENTION_DAYS = int(os.environ.get('BACKUP_RETENTION_DAYS'))

# Boto3 client
backup_client = boto3.client('backup', region_name=BACKUP_REGION)

def lambda_handler(event, context):
    logger.debug(f"Event data: {event}")

    source_backup_vault_name = event['detail']['destinationBackupVaultArn'].split(':')[6]
    recovery_point_arn = event['detail']['destinationRecoveryPointArn']
    logger.info(f"Recovery Point ARN to be copied: {recovery_point_arn}")

    # Boto3 call to retrieve recovery point retention/lifecycle value
    recovery_point = backup_client.describe_recovery_point(
        BackupVaultName=source_backup_vault_name,
        RecoveryPointArn=recovery_point_arn
    )
    logger.debug(f"Recovery Point data: {recovery_point}")

    response = backup_client.start_copy_job(
        RecoveryPointArn=recovery_point_arn,
        SourceBackupVaultName=source_backup_vault_name,
        DestinationBackupVaultArn=DESTINATION_BACKUP_VAULT_ARN,
        IamRoleArn=IAM_BACKUP_ROLE_ARN,
        Lifecycle={
            'DeleteAfterDays': BACKUP_RETENTION_DAYS,
        }
    )

    logger.info(f"AWS Backup Copy Job ID: {response['CopyJobId']}")

    return json.dumps(response, default=str)
