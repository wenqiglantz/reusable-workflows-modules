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
  default     = ""
}

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The VPC cidr block"
  type        = string
}

variable "private_subnets" {
  type        = list
  description = "List of private subnet ids"
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
  description = "The ARN of the ALB target group"
}

variable "alb_security_group_id" {
  default     = "default"
  description = "The ALB security group id"
}

variable "ecs_service_sg_name" {
  default     = "default"
  description = "The name of the ECS service security group"
}

variable "ecr_repository_name" {
  default     = "default"
  description = "The ECR repository name"
}

variable "service_port_target_group" {
  description = "application's service port"
  type        = number
  default     = 8080
}

variable "use_existing_cloudwatch_log_group" {
  description = "flag to indicate whether or not to use existing cloudwatch log group"
  type        = bool
  default     = true
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

variable "deploy_repo" {
  description = "GitHub repo passed in from CI workflow"
  type    = string
  default = ""
}

variable "deploy_env" {
  description = "Deployment environment passed in from CI workflow"
  type    = string
  default = "dev"
}

variable "pipeline_token" {
  description = "GitHub token passed in from CI workflow"
  type    = string
  default = ""
}
