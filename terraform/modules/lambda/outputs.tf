output "lambda_function_arn" {
  value = module.lambda_function
}

output "lambda_name" {
  value = {for k, v in module.lambda_function: k => v.function_name}
  description = "Lambda function names in key/value map"
}

output "lambda_arn" {
  value = {for k, v in module.lambda_function: k => v.arn}
  description = "Lambda function ARNs in key/value map"
}