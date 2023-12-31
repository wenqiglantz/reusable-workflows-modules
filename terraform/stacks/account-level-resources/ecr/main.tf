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

resource "aws_ecr_repository" "my_ecr_repo" {
  name = lower(var.ecr_repo_name)
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "my_ecr_lifecycle_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name
  policy     = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images older than x number of days"
        selection    = {
          tagStatus   = var.lifecycle_tag_status
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.lifecycle_days_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository_policy" "my_ecr_repo_policy" {
  repository = aws_ecr_repository.my_ecr_repo.name
  policy     = jsonencode({
    Version   = "2008-10-17",
    Statement = [
      {
        Sid       = "AllowPushPull",
        Effect    = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::342212914682:role/Terraform_role", #todo
          ]
        },
        Action = "ecr:*"
      }
    ]
  })
}

