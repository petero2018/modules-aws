#!/bin/bash

OUT=$(aws sts assume-role --role-arn "${AWS_ROLE}" --role-session-name OpenSearchRequest);\
export AWS_ACCESS_KEY_ID=$(echo $OUT | jq -r '.Credentials''.AccessKeyId');\
export AWS_SECRET_ACCESS_KEY=$(echo $OUT | jq -r '.Credentials''.SecretAccessKey');\
export AWS_SESSION_TOKEN=$(echo $OUT | jq -r '.Credentials''.SessionToken');

curl \
  --request ${HTTP_METHOD} "https://${OS_ENDPOINT}/${HTTP_PATH}" \
  --aws-sigv4 "aws:amz:${AWS_REGION}:es" \
  --user "$AWS_ACCESS_KEY_ID:$AWS_SECRET_ACCESS_KEY" \
  -H "x-amz-security-token:$AWS_SESSION_TOKEN" \
  -H 'Content-Type: application/json' \
  -d "${HTTP_BODY}"
