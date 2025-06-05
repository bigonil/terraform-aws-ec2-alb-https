#!/bin/bash

USER_NAME="lb-aws-admin"
PROFILE="lb-aws-admin"

echo "Ì¥ç Scanning assume-role permissions for IAM user: $USER_NAME"

# Get all attached managed policy ARNs
policy_arns=$(aws iam list-attached-user-policies \
  --user-name "$USER_NAME" \
  --profile "$PROFILE" \
  --query 'AttachedPolicies[*].PolicyArn' \
  --output text)

for policy_arn in $policy_arns; do
  echo "Ì≥Ñ Checking policy: $policy_arn"
  
  # Get default version
  version_id=$(aws iam get-policy \
    --policy-arn "$policy_arn" \
    --profile "$PROFILE" \
    --query 'Policy.DefaultVersionId' \
    --output text)

  # Get raw policy document (URL-encoded JSON)
  encoded_doc=$(aws iam get-policy-version \
    --policy-arn "$policy_arn" \
    --version-id "$version_id" \
    --profile "$PROFILE" \
    --query 'PolicyVersion.Document' \
    --output text)

  # Grep all lines with sts:AssumeRole and print the Resource line
  echo "$encoded_doc" | grep -A5 "sts:AssumeRole" | grep "arn:aws:iam::" | sed 's/[",]//g' | awk '{$1=$1};1'
done

