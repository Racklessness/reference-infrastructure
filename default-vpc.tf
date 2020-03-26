resource "aws_default_vpc" "default" {
}

data "aws_subnet_ids" "default_subnets" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_iam_policy" "serverless_journey_vpc_acces_policy" {
  name = "vpc_network_interface_management"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}