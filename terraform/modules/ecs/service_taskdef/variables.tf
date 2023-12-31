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

variable "cluster_name" {
  description = "Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
}

variable "cpu" {
  description = "The CPU size"
  type        = number
  default     = 512
}

variable "memory" {
  description = "The memory size"
  type        = number
  default     = 1024
}

variable "service_name" {
  type        = string
  description = "service name, the same as the ECR image name"
}

variable "operating_system_family" {
  description = "ECS task definition's operating system family, such as LINUX, WINDOWS_SERVER_2019_FULL, etc."
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "ECS task definition's CPU architecture, either X86_64 or ARM64"
  type        = string
  default     = "X86_64"
}

variable "alb_target_group_arn" {
  default     = "default"
  type        = string
  description = "The ARN of the ALB target group"
}

variable "alb_security_group_id" {
  default     = "default"
  type        = string
  description = "The ALB security group id"
}

variable "ecr_repository_name" {
  default     = "default"
  type        = string
  description = "The ECR repository name"
}

variable "log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, etc."
  type        = number
  default     = 7
}

variable "parameter_store_entries" {
  description = "Map of parameter store entries, if no param store needed, leave as empty"
  type        = map(any)
  default     = {}
}

variable "create_cluster" {
  description = "flag to create new cluster or use existing one"
  type        = bool
  default     = true
}

variable "healthcheck_path" {
  description = "application's health check path"
  type        = string
  default     = ""
}

variable "service_port_target_group" {
  description = "application's service port"
  type        = string
  default     = "8080"
}

variable "target_group_name" {
  default     = "default"
  type        = string
  description = "The name of the target group"
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix"
  type        = string
}

variable "alb_request_count_per_target" {
  description = "ALB request count per target, used for target_tracking_scaling_policy_configuration"
  type        = string
}

variable "ecs_autoscaling_target_max_capacity" {
  description = "ecs autoscaling target max_capacity"
  type        = number
}

variable "ecs_autoscaling_target_min_capacity" {
  description = "ecs autoscaling target min_capacity"
  type        = number
}
