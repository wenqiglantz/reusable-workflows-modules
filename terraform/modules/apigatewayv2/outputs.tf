output "base_url" {
  description = "Base URL for HTTP API Gateway stage."
  value = aws_apigatewayv2_stage.apigateway.invoke_url
}