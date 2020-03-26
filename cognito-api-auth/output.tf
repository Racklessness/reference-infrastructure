output "user-pool-id" {
  value = aws_cognito_user_pool.user-pool.id
}

output "user-pool-arn" {
  value = aws_cognito_user_pool.user-pool.arn
}

output "user-pool-name" {
  value = aws_cognito_user_pool.user-pool.name
}

output "user-pool-web-client-id" {
  value = aws_cognito_user_pool_client.user-pool-client.id
}

output "user-pool-web-client-url" {
  value = "${aws_cognito_user_pool.user-pool.name}.auth.us-east-1.amazoncognito.com"
}
