# Broken Terraform and Lambda Project

This is a project that has issues with Terraform and a simple AWS Lambda function.

## Setup

1. Fork this repository.
2. Clone your fork.
3. Run `terraform init` and `terraform apply` in the `/` directory.
4. Debug and fix the issues.

## Run

1. Execute `terraform apply` to create the resources.
2. Test the Lambda function to make sure it's working as expected.

## Root Cause & Solution

### Root Cause:
The Lambda function lacked the necessary IAM permissions to read the deployment package from the S3 bucket, causing execution failures.

### Solution:
Added an IAM policy that grants the Lambda function `s3:GetObject` permissions for the specific S3 object (`lambda_function_payload.zip`) and attached it to the Lambda's IAM role.
