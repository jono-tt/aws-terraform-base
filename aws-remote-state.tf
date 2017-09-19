variable "aws_state_bucket_name" {
}

variable "aws_state_bucket_key" {
}

variable "aws_state_bucket_region" {
}

variable "aws_state_bucket_access_key" {
}

variable "aws_state_bucket_access_secret" {
}

terraform {
  required_version = ">= 0.9.6"

  backend "s3" {}
}

data "terraform_remote_state" "tfstate" {
  backend = "s3"
  config {
    bucket = "${var.aws_state_bucket_name}"
    key = "${var.aws_state_bucket_key}"
    region = "${var.aws_state_bucket_region}"
    access_key = "${var.aws_state_bucket_access_key}"
    secret_key = "${var.aws_state_bucket_access_secret}"
  }
}
