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

#######################################
# S3 Bucket for remote state management
#######################################
resource "aws_s3_bucket" "remote_state_bucket" {
  bucket = var.s3_bucket_remote_state
}

resource "aws_s3_bucket" "remote_state_bucket_logging" {
  bucket = "${var.s3_bucket_remote_state}-logs"
}

resource "aws_s3_bucket_public_access_block" "remote_state_bucket" {
  bucket = aws_s3_bucket.remote_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "remote_state_bucket_logging" {
  bucket = aws_s3_bucket.remote_state_bucket_logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# added as recommended by Checkov scanning
resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state_bucket" {
  bucket = var.s3_bucket_remote_state
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# added as recommended by Checkov scanning
resource "aws_s3_bucket_versioning" "remote_state_bucket" {
  bucket = var.s3_bucket_remote_state
  versioning_configuration {
    status = "Enabled"
  }
}

# added as recommended by Checkov scanning
resource "aws_s3_bucket_logging" "remote_state_bucket" {
  bucket        = var.s3_bucket_remote_state
  target_bucket = "${var.s3_bucket_remote_state}-logs"
  target_prefix = "log/${var.s3_bucket_remote_state}"
}

#######################################
# aws_dynamodb_table for remote state lock
#######################################
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform_state_lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
