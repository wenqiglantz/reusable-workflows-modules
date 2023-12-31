variable "deploy_env" {
  description = "CI injected variable, deployment environment"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "requester_name" {
  description = "requestor name tag"
  type        = string
}

variable "create_vpc" {
  description = "flag to create new VPC or use existing one"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
  type        = string
}

variable "public_subnets_cidr" {
  description = "The CIDR block for the public subnet"
  type        = list
}

variable "private_subnets_cidr" {
  description = "The CIDR block for the private subnet"
  type        = list
}