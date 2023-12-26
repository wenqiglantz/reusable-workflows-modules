variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
}

variable "requester_name" {
  description = "requester name tag"
  type        = string
}

variable "ecr_repo_name" {
  description = "ECR repo name"
  type        = string
}

variable "lifecycle_tag_status" {
  description = "Lifecycle tag status"
  type        = string
  default     = "any"
}

variable "lifecycle_days_count" {
  description = "The number of days the images remain in ECR before they expire"
  type        = number
  default     = 30
}

variable "deploy_env" {
  description = "Deployment environment passed in from CI workflow"
  type        = string
  default     = "dev"
}