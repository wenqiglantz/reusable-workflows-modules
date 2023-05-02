<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.65.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.65.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.apigateway](https://registry.terraform.io/providers/hashicorp/aws/4.65.0/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_deployment.apigateway](https://registry.terraform.io/providers/hashicorp/aws/4.65.0/docs/resources/apigatewayv2_deployment) | resource |
| [aws_apigatewayv2_route.apigateway](https://registry.terraform.io/providers/hashicorp/aws/4.65.0/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.apigateway](https://registry.terraform.io/providers/hashicorp/aws/4.65.0/docs/resources/apigatewayv2_stage) | resource |
| [aws_cloudwatch_log_group.apigateway](https://registry.terraform.io/providers/hashicorp/aws/4.65.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_permission.apigateway](https://registry.terraform.io/providers/hashicorp/aws/4.65.0/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_gateway_stage_name"></a> [api\_gateway\_stage\_name](#input\_api\_gateway\_stage\_name) | HTTP API Gateway stage name | `string` | `""` | no |
| <a name="input_api_gw_log_group_retention_in_days"></a> [api\_gw\_log\_group\_retention\_in\_days](#input\_api\_gw\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, etc. | `number` | `7` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for all resources. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | HTTP API Gateway description | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment | `string` | `"dev"` | no |
| <a name="input_http_api_gateway_name"></a> [http\_api\_gateway\_name](#input\_http\_api\_gateway\_name) | HTTP API Gateway name | `string` | `""` | no |
| <a name="input_lambda_function"></a> [lambda\_function](#input\_lambda\_function) | Lambda function name integrated with API Gateway | `string` | `""` | no |
| <a name="input_open_api_spec"></a> [open\_api\_spec](#input\_open\_api\_spec) | OpenAPI Spec | `any` | n/a | yes |
| <a name="input_stage_variables"></a> [stage\_variables](#input\_stage\_variables) | API Gateway stage variables | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_base_url"></a> [base\_url](#output\_base\_url) | Base URL for HTTP API Gateway stage. |
<!-- END_TF_DOCS -->