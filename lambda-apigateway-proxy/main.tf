/**
 * First the base API gateway setup
 */

resource "aws_api_gateway_rest_api" "service" {
  name = var.name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

/**
 * If a Cognito user pool arn is passed in,
 * we want to create the authoriser and use that to authenticate our API.
 * At the moment the only real way to achieve this is through a count param.
 * If you know of a better way, please open a PR or Github issue :)
 */
resource "aws_api_gateway_authorizer" "service_authoriser" {
  name = "${var.name}-authoriser"
  count = var.cognito_authoriser_pool_arn == null ? 0 : 1
  type = "COGNITO_USER_POOLS"
  provider_arns = [var.cognito_authoriser_pool_arn]
  rest_api_id = aws_api_gateway_rest_api.service.id
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.service.id
  parent_id   = aws_api_gateway_rest_api.service.root_resource_id
  path_part   = "{proxy+}"
}

locals {
  api_methods = ["GET", "POST", "PUT", "PATCH", "DELETE"]
}

resource "aws_api_gateway_method" "proxy" {
  count = length(local.api_methods)
  rest_api_id   = aws_api_gateway_rest_api.service.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = element(local.api_methods, count.index)
  authorization = var.cognito_authoriser_pool_arn == null ? "NONE" : "COGNITO_USER_POOLS"
  authorizer_id = var.cognito_authoriser_pool_arn == null ? null : aws_api_gateway_authorizer.service_authoriser[0].id
  authorization_scopes = var.cognito_authoriser_scopes
}

resource "aws_api_gateway_integration" "proxy_lambda" {
  count = length(local.api_methods)
  rest_api_id = aws_api_gateway_rest_api.service.id
  resource_id = aws_api_gateway_method.proxy[count.index].resource_id
  http_method = aws_api_gateway_method.proxy[count.index].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_method" "proxy_cors" {
  rest_api_id   = aws_api_gateway_rest_api.service.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_cors_lambda" {
  rest_api_id = aws_api_gateway_rest_api.service.id
  resource_id = aws_api_gateway_method.proxy_cors.resource_id
  http_method = aws_api_gateway_method.proxy_cors.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  count = length(local.api_methods)
  rest_api_id   = aws_api_gateway_rest_api.service.id
  resource_id   = aws_api_gateway_rest_api.service.root_resource_id
  http_method   = element(local.api_methods, count.index)
  authorization = var.cognito_authoriser_pool_arn == null ? "NONE" : "COGNITO_USER_POOLS"
  authorizer_id = var.cognito_authoriser_pool_arn == null ? null : aws_api_gateway_authorizer.service_authoriser[0].id
  authorization_scopes = var.cognito_authoriser_scopes
}

resource "aws_api_gateway_integration" "proxy_root_lambda" {
  count = length(local.api_methods)
  rest_api_id = aws_api_gateway_rest_api.service.id
  resource_id = aws_api_gateway_method.proxy_root[count.index].resource_id
  http_method = aws_api_gateway_method.proxy_root[count.index].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_method" "proxy_root_cors" {
  rest_api_id   = aws_api_gateway_rest_api.service.id
  resource_id   = aws_api_gateway_rest_api.service.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_root_cors_lambda" {
  rest_api_id = aws_api_gateway_rest_api.service.id
  resource_id = aws_api_gateway_method.proxy_root_cors.resource_id
  http_method = aws_api_gateway_method.proxy_root_cors.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "api_gateway_deployment_prod" {
  depends_on = [
    aws_api_gateway_integration.proxy_lambda,
    aws_api_gateway_integration.proxy_cors_lambda,
    aws_api_gateway_integration.proxy_root_lambda,
    aws_api_gateway_integration.proxy_root_cors_lambda,
  ]

  rest_api_id = aws_api_gateway_rest_api.service.id
  stage_name   = "prod"
}

resource "aws_lambda_permission" "api_gateway_lambda_invoke" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.service.execution_arn}/*/*"
}
