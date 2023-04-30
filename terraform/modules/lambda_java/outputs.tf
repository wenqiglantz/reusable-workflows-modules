output "lambda_name" {
  value = aws_lambda_function.lambda_function.function_name
  description = "Lambda function name"
}

output "lambda_arn" {
  value = aws_lambda_function.lambda_function.arn
  description = "Lambda function ARN"
}
