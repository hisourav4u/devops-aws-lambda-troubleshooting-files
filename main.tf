provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-super-cool-bucket"
  acl    = "private"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda"

  s3_bucket = aws_s3_bucket.my_bucket.bucket
  s3_key    = "lambda_function_payload.zip"

  handler = "handler.handler"
  runtime = "python3.8"

  role = aws_iam_role.iam_for_lambda.arn
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# add an IAM policy that grants the Lambda function read access (s3:GetObject) to the specific S3 object
# (lambda_function_payload.zip). Without this, the Lambda function cannot retrieve its deployment package.
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3-access-policy"
  description = "Allows Lambda to access S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:GetObject"],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::my-super-cool-bucket/lambda_function_payload.zip"
      }
    ]
  })
}

# The policy is then attached to the Lambda's IAM role to ensure it has the necessary permissions.
resource "aws_iam_role_policy_attachment" "lambda_s3_attach" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.iam_for_lambda.name
}

