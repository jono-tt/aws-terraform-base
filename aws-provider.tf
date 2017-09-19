variable "aws_target_access_key" {
  description = "The AWS access key."
}

variable "aws_target_access_secret" {
  description = "The AWS secret key."
}

variable "aws_target_region" {
  description = "The AWS region to create resources in."
}

provider "aws" {
  access_key = "${var.aws_target_access_key}"
  secret_key = "${var.aws_target_access_secret}"
  region = "${var.aws_target_region}"
}
