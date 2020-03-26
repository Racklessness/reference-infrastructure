variable "name" {
  type = string
}

variable "storage_bucket" {
  type = string
}

variable "file_name" {
  type = string
  default = "function.zip"
}

variable "file_version" {
  type = string
  description = "Version of the file to use in S3"
}

variable "handler" {
  type = string
  description = "Handler to call when starting the Lambda Function"
}

variable "runtime" {
  type = string
}

variable "subnet_ids" {
  type = list
  default = []
}

variable "security_group_ids" {
  type = list
  default = []
}

variable "env_variables" {
  type = map
  default = {}
}
