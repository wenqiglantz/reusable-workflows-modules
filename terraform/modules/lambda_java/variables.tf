#variable "aws_region" {
#  description = "AWS region for all resources."
#  type        = string
#  default     = ""
#}
#
#variable "environment" {
#  description = "Deployment environment"
#  type        = string
#  default     = "dev"
#}

variable "resource_name_prefix" {
  type        = string
  description = "Resource name prefix, used in role name"
  default     = ""
}

variable "lambda_code_file" {
  type        = string
  description = "Lambda code jar file"
  default     = ""
}

variable "lambda_archive_path" {
  type        = string
  description = "Lambda code archive path"
  default     = ""
}

variable "lambda_function" {
  description = "Lambda function details"
  type        = map(any)
  default     = {
    function_name          = "chat"
    runtime                = "java17"
    handler                = "org.springframework.cloud.function.adapter.aws.FunctionInvoker"
    ephemeral_storage      = "512"
    memory_size            = "128"
    function_name_variable = "chat"
  }
}

variable "lambda_log_retention_in_days" {
  description = "Log retention in days"
  type        = number
  default     = 7
}

variable "api_key" {
  description = "API key"
  type        = string
  default     = ""
}
