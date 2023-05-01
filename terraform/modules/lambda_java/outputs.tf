output "lambda_name" {
  value       = aws_lambda_function.lambda_function.function_name
  description = "Lambda function name"
}

output "lambda_arn" {
  value       = aws_lambda_function.lambda_function.arn
  description = "Lambda function ARN"
}

output "qualified_arn" {
  value       = aws_lambda_function.lambda_function.qualified_arn
  description = "ARN identifying your Lambda Function Version (if versioning is enabled via publish = true)"
}

output "qualified_invoke_arn" {
  value       = aws_lambda_function.lambda_function.qualified_invoke_arn
  description = "Qualified ARN (ARN with lambda version number) to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri"
}