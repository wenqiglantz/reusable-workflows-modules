variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "deploy_env" {
  description = "Deployment environment passed in from CI workflow"
  type        = string
  default     = "dev"
}

variable "requester_name" {
  description = "requester name tag"
  type        = string
}

variable "s3_bucket_remote_state" {
  description = "S3 bucket name for Terraform remote state management"
  type        = string
}
