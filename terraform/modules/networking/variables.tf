variable "deploy_env" {
  description = "Deployment environment passed in from CI workflow"
  type        = string
  default     = "dev"
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

variable "create_vpc" {
  description = "flag to create new VPC or use existing one"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
  type        = string
}

variable "availability_zones" {
  description = "The az that the resources will be launched"
  type        = list
}

variable "public_subnets_cidr" {
  description = "The CIDR block for the public subnet"
  type        = list
}

variable "private_subnets_cidr" {
  description = "The CIDR block for the private subnet"
  type        = list
}
