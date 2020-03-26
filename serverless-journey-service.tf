resource "aws_iam_role_policy_attachment" "service_logging_policy_attachment" {
  role = module.serverless-journey-lambda.role_name
  policy_arn = aws_iam_policy.serverless_journey_vpc_acces_policy.arn
}

# Allow out function to send SQS messages
resource "aws_iam_role_policy_attachment" "service_sqs_policy_attachment_queue_producer" {
  role = module.serverless-journey-lambda.role_name
  policy_arn = aws_iam_policy.serverless-journey-default-queue-producer-policy.arn
}

module "serverless-journey-lambda" {
  source = "./lambda-deployment"
  name = "serverless-journey"
  handler = "src/http/lambda.handler"
  storage_bucket = module.serverless-journey-storage-bucket.storage-bucket
  file_name = "function.zip"
  file_version = var.serverless_journey_file_version
  runtime = "nodejs12.x"
  subnet_ids = data.aws_subnet_ids.default_subnets.ids
  security_group_ids = aws_db_instance.serverless-journey-db.vpc_security_group_ids
  env_variables = merge(local.common_lambda_env, {})
}

module "serverless-journey-logging" {
  source = "./lambda-logging-permission"
  name = "serverless-journey"
  lambda_role_name = module.serverless-journey-lambda.role_name
}

module "serverless-journey-apigateway-proxy" {
  source = "./lambda-apigateway-proxy"
  name = "serverless-journey"
  lambda_name = module.serverless-journey-lambda.function_name
  lambda_invoke_arn = module.serverless-journey-lambda.invoke_arn
  cognito_authoriser_pool_arn = module.serverless-journey-auth.user-pool-arn
  cognito_authoriser_scopes = [
    "serverless-journey.app/api"
  ]
}
