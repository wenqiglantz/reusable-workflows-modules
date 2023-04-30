output "lambda_name" {
  value = {for k, v in aws_lambda_function.lambda_function: k => v.function_name}
  description = "Lambda function names in key/value map"
}

output "lambda_arn" {
  value = {for k, v in aws_lambda_function.lambda_function: k => v.arn}
  description = "Lambda function ARNs in key/value map"
}
