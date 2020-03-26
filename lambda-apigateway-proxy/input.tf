variable "name" {
  type = string
}

variable "lambda_invoke_arn" {
  type = string
}


variable "lambda_name" {
  type = string
}

variable "cognito_authoriser_pool_arn" {
  type = string
  default = null
}

variable "cognito_authoriser_scopes" {
  type = list(string)
  default = []
}
