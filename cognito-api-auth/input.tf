variable "name" {
  type = string
}

variable "domain_name" {
  type = string
  default = ""
}

variable "identifier" {
  type = string
}

variable "callback_urls" {
  type = list(string)
}

variable "logout_urls" {
  type = list(string)
}

variable "additional_identity_providers" {
  type = list(string)
  default = []
}
