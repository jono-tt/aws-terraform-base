#! /bin/sh -e

# export AWS_ACCESS_KEY_ID= <your key> # to store and retrieve the remote state in s3.
# export AWS_SECRET_ACCESS_KEY= <your secret>
# export AWS_BUCKET_DEFAULT_REGION= <your bucket region e.g. us-west-2>

required_env_vars="AWS_STATE_BUCKET_ACCESS_KEY AWS_STATE_BUCKET_ACCESS_SECRET AWS_STATE_BUCKET_REGION AWS_STATE_BUCKET_NAME AWS_STATE_BUCKET_PROJECT_NAME AWS_STATE_BUCKET_ENVIRONMENT_NAME"
env_missing=false

for VAR in $required_env_vars; do
  VAL=`printenv ${VAR} || echo ''`

  if [ -z "$VAL" ]; then
    echo "Environment param required: ${VAR}"
    env_missing=true
  fi
done

if [ $env_missing == true ]; then
  return 1
fi

# EXPORT TF VARS to be used in TF variables
export TF_VAR_aws_state_bucket_name=${AWS_STATE_BUCKET_NAME}
export TF_VAR_aws_state_bucket_access_key=${AWS_STATE_BUCKET_ACCESS_KEY}
export TF_VAR_aws_state_bucket_access_secret=${AWS_STATE_BUCKET_ACCESS_SECRET}
export TF_VAR_aws_state_bucket_region=${AWS_STATE_BUCKET_REGION}
export TF_VAR_aws_state_bucket_key="${AWS_STATE_BUCKET_PROJECT_NAME}/${AWS_STATE_BUCKET_ENVIRONMENT_NAME}/terraform.tfstate"

export TF_VAR_aws_target_access_key=${AWS_TARGET_ACCESS_KEY-$AWS_STATE_BUCKET_ACCESS_KEY}
export TF_VAR_aws_target_access_secret=${AWS_TARGET_ACCESS_SECRET-$AWS_STATE_BUCKET_ACCESS_SECRET}
export TF_VAR_aws_target_region=${AWS_TARGET_REGION-$AWS_STATE_BUCKET_REGION}

# Init the backend configs
terraform init -backend-config="bucket=${AWS_STATE_BUCKET_NAME}" -backend-config="key=${TF_VAR_aws_state_bucket_key}" -backend-config="region=${AWS_STATE_BUCKET_REGION}" -backend=true -backend-config="access_key=${AWS_STATE_BUCKET_ACCESS_KEY}" -backend-config="secret_key=${AWS_STATE_BUCKET_ACCESS_SECRET}"

echo -e "\nSet S3 State Store in bucket: ${TF_VAR_aws_state_bucket_key}"

# Execute the originally passed in command
echo -e "\nExecuting command: ${@}\n\n"
exit_code=0
$@ || exit_code=$? && true

# Report the exit status
if [[ $exit_code -eq 0 ]]; then
  echo -e "\nSuccess"
else
  echo -e "\nFailed: ${exit_code}"
  exit $exit_code
fi
