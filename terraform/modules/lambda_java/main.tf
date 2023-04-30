terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.65.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # default tags per https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  default_tags {
    tags = {
      env            = var.environment
      ManagedBy      = "Terraform"
    }
  }
}

provider "archive" {}

resource "random_string" "random_string" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = false
}

data "archive_file" "lambda_zip" {
  source_dir  = var.lambda_code_path
  output_path = var.lambda_archive_path
  type        = "zip"
}

data "aws_iam_policy_document" "simple_lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "lambda" {
  name                = "${var.resource_name_prefix}-role-${random_string.random_string.result}"
  assume_role_policy  = data.aws_iam_policy_document.simple_lambda_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function.function_name
  runtime       = var.lambda_function.runtime
  handler       = var.lambda_function.handler
  memory_size   = var.lambda_function.memory_size
  ephemeral_storage {
    size = var.lambda_function.ephemeral_storage
  }

  filename = data.archive_file.lambda_zip.output_path
  role     = aws_iam_role.lambda.arn

  tracing_config {
    mode = "PassThrough"
  }

  environment {
    variables = {
      SPRING_CLOUD_FUNCTION_DEFINITION = var.lambda_function.function_name_variable
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  for_each          = aws_lambda_function.lambda_function
  name              = "/aws/lambda/${each.value.function_name}"
  retention_in_days = var.lambda_log_retention_in_days
}
