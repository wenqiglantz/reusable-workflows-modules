variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to store the Lambda function code"
  default     = ""
}

variable "s3_object_key" {
  type        = string
  description = "The S3 bucket object key, referring to the zip file"
  default     = ""
}

variable "lambda_jar_relative_path" {
  type        = string
  description = "The relative path of the Lambda jar file"
  default     = ""
}
