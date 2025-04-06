#!/bin/bash


# /scripts/chekck_key.sh
# Read input from Terraform
read input
KEY_NAME=$(echo "$input" | jq -r .key_name)

# Ask AWS if that key exists
if aws ec2 describe-key-pairs --key-names "$KEY_NAME" > /dev/null 2>&1; then
  echo '{"exists": "true"}'   # Tell Terraform: yep, it exists
else
  echo '{"exists": "false"}'  # Tell Terraform: nope, not here
fi
