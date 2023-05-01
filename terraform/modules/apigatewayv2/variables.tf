variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = ""
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "open_api_spec" {
  type        = any
  description = "OpenAPI Spec"
}

variable "api_gw_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, etc."
  type        = number
  default     = 7
}

variable "http_api_gateway_name" {
  description = "HTTP API Gateway name"
  type        = string
  default     = ""
}

variable "description" {
  description = "HTTP API Gateway description"
  type        = string
  default     = ""
}

variable "api_gateway_stage_name" {
  description = "HTTP API Gateway stage name"
  type        = string
  default     = ""
}

variable "stage_variables" {
  description = "API Gateway stage variables"
  type        = map(any)
  default     = {}
}

variable "lambda_function" {
  type        = string
  description = "Lambda function name integrated with API Gateway"
  default     = ""
}
