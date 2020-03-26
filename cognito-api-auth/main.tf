resource "aws_cognito_user_pool" "user-pool" {
  name = var.name

  username_attributes = [
    "email"
  ]

  auto_verified_attributes = [
    "email"
  ]
}

resource "aws_cognito_resource_server" "user-pool-resource-server" {
  identifier = var.identifier
  name       = var.name

  scope {
    scope_name        = "api"
    scope_description = "Access to apis"
  }

  user_pool_id = aws_cognito_user_pool.user-pool.id
}


resource "aws_cognito_user_pool_client" "user-pool-client" {
  depends_on = [
    aws_cognito_resource_server.user-pool-resource-server
  ]
  name = var.name

  user_pool_id = aws_cognito_user_pool.user-pool.id

  generate_secret = false

  supported_identity_providers = setunion([
    "COGNITO",
  ], var.additional_identity_providers)

  allowed_oauth_flows = [
    "code",
  ]

  allowed_oauth_scopes = [
    "email",
    "openid",
    "${var.identifier}/api",
  ]

  allowed_oauth_flows_user_pool_client = true

  callback_urls = var.callback_urls

  logout_urls = var.logout_urls

}

resource "aws_cognito_user_pool_domain" "user-pool-domain" {
  user_pool_id    = aws_cognito_user_pool.user-pool.id
  domain          = var.domain_name != "" ? var.domain_name : var.name
}

