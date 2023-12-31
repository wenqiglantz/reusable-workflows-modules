#######################################
# Provider
#######################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "aws" {
  region = var.aws_region
  # default tags per https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  default_tags {
    tags = {
      requester = var.requester_name
      env       = var.deploy_env
      ManagedBy = "Terraform"
    }
  }
}

module "networking" {
  source = "github.com/wenqiglantz/reusable-workflows-modules//terraform/modules/networking?ref=main"

  deploy_env     = var.deploy_env
  requester_name = var.requester_name

  create_vpc           = var.create_vpc
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
}
