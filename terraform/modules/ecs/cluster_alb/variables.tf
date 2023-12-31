variable "requester_name" {
  description = "requester name tag"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "github_repo_owner" {
  description = "GitHub repo owner"
  type        = string
}

variable "create_cluster" {
  description = "flag to create new cluster or use existing one"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
}

variable "service_port" {
  description = "application's service port"
  type        = string
  default     = "443"
}

variable "alb_name" {
  default     = "default"
  type        = string
  description = "The name of the loadbalancer"
}

variable "target_group_name" {
  default     = "default"
  type        = string
  description = "The name of the target group"
}

variable "service_port_target_group" {
  description = "application's service port"
  type        = string
  default     = "8080"
}

variable "context_path" {
  description = "application's context path, used for ALB listener rule configuration"
  type        = string
  default     = ""
}

variable "healthcheck_path" {
  description = "application's health check path"
  type        = string
  default     = ""
}

variable "alb_https_certificate_arn" {
  description = "ALB HTTPS certification arn"
  type        = string
  default     = ""
}

variable "deploy_repo" {
  description = "GitHub repo passed in from CI workflow"
  type        = string
  default     = ""
}

variable "deploy_env" {
  description = "Deployment environment passed in from CI workflow"
  type        = string
  default     = "dev"
}

variable "pipeline_token" {
  description = "GitHub token passed in from CI workflow"
  type        = string
  default     = ""
}
