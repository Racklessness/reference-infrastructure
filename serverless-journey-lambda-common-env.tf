locals {
  common_lambda_env = {
    DB_PORT = aws_db_instance.serverless-journey-db.port
    DB_HOST = aws_db_instance.serverless-journey-db.address
    DB_NAME = aws_db_instance.serverless-journey-db.name
    DB_USERNAME = aws_db_instance.serverless-journey-db.username
    DB_PASSWORD = aws_db_instance.serverless-journey-db.password
    SQS_QUEUE_URL = data.aws_sqs_queue.serverless-journey-default-queue.url
  }
}
