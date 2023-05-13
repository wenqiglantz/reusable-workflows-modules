terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.66"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # default tags per https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  default_tags {
    tags = {
      env       = var.environment
      ManagedBy = "Terraform"
    }
  }
}

#######################################
# HTTP API Gateway
#######################################
resource "aws_apigatewayv2_api" "apigateway" {
  name          = var.http_api_gateway_name
  description   = var.description
  protocol_type = "HTTP"
  body          = var.open_api_spec
}

#######################################
# aws_apigatewayv2_deployment
#######################################
resource "aws_apigatewayv2_deployment" "apigateway" {
  api_id      = aws_apigatewayv2_api.apigateway.id
  description = "HTTP API Gateway deployment"

  depends_on = [
    aws_apigatewayv2_api.apigateway
  ]

  lifecycle {
    create_before_destroy = true
  }
}

#######################################
# aws_apigatewayv2_route
#######################################
# resource "aws_apigatewayv2_route" "apigateway" {
#   api_id    = aws_apigatewayv2_api.apigateway.id
#   route_key = "$default"
# }

#######################################
# aws_apigatewayv2_stage
#######################################
resource "aws_apigatewayv2_stage" "apigateway" {
  api_id        = aws_apigatewayv2_api.apigateway.id
  name          = var.api_gateway_stage_name
  #deployment_id = aws_apigatewayv2_deployment.apigateway.id

  stage_variables = var.stage_variables
  auto_deploy     = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigateway.arn
    format          = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    }
    )
  }
}

#######################################
# aws_cloudwatch_log_group
#######################################
resource "aws_cloudwatch_log_group" "apigateway" {
  name              = "/aws/api_gw/${aws_apigatewayv2_api.apigateway.name}"
  retention_in_days = var.api_gw_log_group_retention_in_days
}

#######################################
# aws_lambda_permission
#######################################
resource "aws_lambda_permission" "apigateway" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.apigateway.execution_arn}/*/*"
}
