resource "aws_iam_role" "service_iam" {
  name = "${var.name}_iam_role"

  /**
   * This is the primary role for the lambda function.
   * All policies and permissions should be attached to this role
   */

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "service" {
  s3_bucket = var.storage_bucket
  s3_key = var.file_name
  s3_object_version = var.file_version
  function_name = var.name
  publish = true
  role = aws_iam_role.service_iam.arn
  handler = var.handler
  runtime = var.runtime

  tracing_config {
    mode = "PassThrough"
  }

  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = var.env_variables
  }
}


