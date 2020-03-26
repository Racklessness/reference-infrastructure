# Configure the AWS Provider

variable "cognito_google_client_id" {
  type = string
}

variable "cognito_google_client_secret" {
  type = string
}

variable "serverless_journey_file_version" {
  type = string
}

provider "aws" {
  version = "~> 2.0"
  region = "us-east-1"
}
