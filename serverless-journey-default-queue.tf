resource "aws_sqs_queue" "serverless-journey-default-queue" {
  name = "serverless-journey-default-queue"
  receive_wait_time_seconds = 20
}

data "aws_sqs_queue" "serverless-journey-default-queue" {
  name = aws_sqs_queue.serverless-journey-default-queue.name
}

resource "aws_iam_policy" "serverless-journey-default-queue-worker-policy" {
  name = "serverless-journey-default-queue-worker-policy"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      "Resource": "${aws_sqs_queue.serverless-journey-default-queue.arn}",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "serverless-journey-default-queue-producer-policy" {
  name = "serverless-journey-default-queue-producer-policy"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:SendMessage"
      ],
      "Resource": "${aws_sqs_queue.serverless-journey-default-queue.arn}",
      "Effect": "Allow"
    }
  ]
}
EOF
}
