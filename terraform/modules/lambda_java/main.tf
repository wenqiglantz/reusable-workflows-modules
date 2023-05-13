resource "random_string" "random_string" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = false
}

data "archive_file" "lambda_zip" {
  source_file = "${path.root}/${var.lambda_code_file}"
  output_path = "${path.root}/${var.lambda_archive_path}"
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
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  ]
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function.function_name
  runtime       = var.lambda_function.runtime
  handler       = var.lambda_function.handler
  memory_size   = var.lambda_function.memory_size
  timeout       = var.lambda_function.timeout
  filename      = data.archive_file.lambda_zip.output_path
  role          = aws_iam_role.lambda.arn

  tracing_config {
    mode = "Active"
  }
  ephemeral_storage {
    size = var.lambda_function.ephemeral_storage
  }

  publish = true
  snap_start {
    apply_on = "PublishedVersions"
  }

  environment {
    variables = {
      SPRING_CLOUD_FUNCTION_DEFINITION = var.lambda_function.function_name_variable
      API_KEY                          = var.api_key
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = var.lambda_log_retention_in_days
}
