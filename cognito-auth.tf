module "serverless-journey-auth" {
  source = "./cognito-api-auth"
  name = "serverless-journey"
  identifier = "serverless-journey.app"
  callback_urls = [
    "http://localhost:8080/authed",
  ]
  logout_urls = [
    "http://localhost:8080/outed"
  ]

  additional_identity_providers = [
    "Google"
  ]
}

resource "aws_cognito_identity_provider" "google_provider" {
  user_pool_id = module.serverless-journey-auth.user-pool-id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    attributes_url = "https://people.googleapis.com/v1/people/me?personFields="
    attributes_url_add_attributes = true
    authorize_scopes = "profile email"
    authorize_url = "https://accounts.google.com/o/oauth2/v2/auth"
    client_id = var.cognito_google_client_id
    client_secret = var.cognito_google_client_secret
    oidc_issuer = "https://accounts.google.com"
    token_request_method = "POST"
    token_url = "https://www.googleapis.com/oauth2/v4/token"
  }

  attribute_mapping = {
    email = "email"
    username = "sub"
  }
}
