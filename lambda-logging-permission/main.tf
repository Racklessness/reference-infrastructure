resource "aws_cloudwatch_log_group" "service_log_group" {
  name = "/aws/lambda/${var.name}"
  retention_in_days = 14
}

resource "aws_iam_policy" "service_logging_policy" {
  name = "${var.name}_logging_policy"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "log_group_arn",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "service_logging_policy_attachment" {
  role = var.lambda_role_name
  policy_arn = aws_iam_policy.service_logging_policy.arn
}
