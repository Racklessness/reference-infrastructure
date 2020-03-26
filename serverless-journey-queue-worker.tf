# Allow our function to log to CloudWatch
module "serverless-journey-queue-worker-logging" {
  source = "./lambda-logging-permission"
  name = "serverless-journey-queue-worker"
  lambda_role_name = module.serverless-journey-lambda-queue-worker.role_name
}

# Allow our function to manage networks to the VPC for database acess
resource "aws_iam_role_policy_attachment" "service_logging_policy_attachment_queue_worker" {
  role = module.serverless-journey-lambda-queue-worker.role_name
  policy_arn = aws_iam_policy.serverless_journey_vpc_acces_policy.arn
}

# Allow out function to receive SQS messages
resource "aws_iam_role_policy_attachment" "service_sqs_policy_attachment_queue_worker" {
  role = module.serverless-journey-lambda-queue-worker.role_name
  policy_arn = aws_iam_policy.serverless-journey-default-queue-worker-policy.arn
}

module "serverless-journey-lambda-queue-worker" {
  source = "./lambda-deployment"
  name = "serverless-journey-queue-worker"
  handler = "src/queue/lambda.handler"
  storage_bucket = module.serverless-journey-storage-bucket.storage-bucket
  file_name = "function.zip"
  file_version = var.serverless_journey_file_version
  runtime = "nodejs12.x"
  subnet_ids = data.aws_subnet_ids.default_subnets.ids
  security_group_ids = aws_db_instance.serverless-journey-db.vpc_security_group_ids
  # Second brace can be used to add or override any env variables
  env_variables = merge(local.common_lambda_env, {})
}

resource "aws_lambda_event_source_mapping" "serverless-journey-lambda-queue-worker-event-source" {
  event_source_arn = aws_sqs_queue.serverless-journey-default-queue.arn
  function_name    = module.serverless-journey-lambda-queue-worker.function_name
  batch_size = 5
}