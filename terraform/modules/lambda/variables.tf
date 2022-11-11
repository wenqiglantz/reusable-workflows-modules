variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to store the Lambda function code"
  default     = ""
}

variable "s3_object_key" {
  type        = string
  description = "The S3 object key, the zip file name"
  default     = ""
}

variable "lambda_functions" {
  description = "Map of Lambda functions"
  type        = map(any)
  default     = {
    incountry-add-authorization = {
      runtime                = "java11"
      handler                = "org.springframework.cloud.function.adapter.aws.FunctionInvoker"
      zip                    = "dataresidency-0.0.1-SNAPSHOT-aws.zip"
      function_name_variable = "addAuthorization"
      ephemeral_storage      = "512"
      memory_size            = "512"
    }
  }
}
