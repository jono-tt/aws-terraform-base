# AWS Terraform Base Docker Image #

Used to connect to an remote state storage in S3. This serves as a base for other terraform templates that can be used to manage infrastructure changes using docker images to control versioning. Running this image allows consistent access and commands to be run to help mitigate against local changes effecting remote deployments.


### Environment Variables ###

Required:

* AWS_STATE_BUCKET_ACCESS_KEY        - AWS Access Key for Bucket access
* AWS_STATE_BUCKET_ACCESS_SECRET     - AWS Access Secret for Bucket access
* AWS_STATE_BUCKET_REGION            - AWS Region
* AWS_STATE_BUCKET_NAME              - AWS Name of the bucket (ie. Global bucket name)
* AWS_STATE_BUCKET_PROJECT_NAME      - Project name for the "application" (used to build the key for the state file)
* AWS_STATE_BUCKET_ENVIRONMENT_NAME  - Environment for this project. (used to build the key for the state file)

Optional:

* AWS_TARGET_ACCESS_KEY              - AWS Target infrastructure access key (Default: AWS_STATE_BUCKET_ACCESS_KEY)
* AWS_TARGET_ACCESS_SECRET           - AWS Target infrastructure access secret (Defaults: AWS_TARGET_ACCESS_SECRET)
* AWS_STATE_BUCKET_REGION            - AWS Target infrastructure region (Defaults: AWS_STATE_BUCKET_REGION)


### USAGE ###

```
# Build
docker build -f docker/Dockerfile -t my-terraform-project .
```

```
# Run (remember to set ENV: -e AWS_STATE_BUCKET_ACCESS_KEY=123)
docker run my-terraform-project terraform apply
```
