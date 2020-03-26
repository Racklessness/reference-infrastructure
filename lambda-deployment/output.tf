output "invoke_arn" {
  value = aws_lambda_function.service.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.service.function_name
}

output "role_arn" {
  value = aws_iam_role.service_iam.arn
}

output "role_name" {
  value = aws_iam_role.service_iam.name
}
