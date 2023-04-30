<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.65.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.3.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.65.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/4.65.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/4.65.0/docs/resources/iam_role) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/4.65.0/docs/resources/lambda_function) | resource |
| [random_string.random_string](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/string) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/2.3.0/docs/data-sources/file) | data source |
| [aws_iam_policy_document.simple_lambda_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/4.65.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for all resources. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment | `string` | `"dev"` | no |
| <a name="input_lambda_archive_path"></a> [lambda\_archive\_path](#input\_lambda\_archive\_path) | Lambda code archive path | `string` | `""` | no |
| <a name="input_lambda_code_path"></a> [lambda\_code\_path](#input\_lambda\_code\_path) | Lambda code path | `string` | `""` | no |
| <a name="input_lambda_function"></a> [lambda\_function](#input\_lambda\_function) | Lambda function details | `map(any)` | <pre>{<br>  "ephemeral_storage": "512",<br>  "function_name": "chat",<br>  "function_name_variable": "chat",<br>  "handler": "org.springframework.cloud.function.adapter.aws.FunctionInvoker",<br>  "memory_size": "128",<br>  "runtime": "java17"<br>}</pre> | no |
| <a name="input_lambda_log_retention_in_days"></a> [lambda\_log\_retention\_in\_days](#input\_lambda\_log\_retention\_in\_days) | Log retention in days | `number` | `7` | no |
| <a name="input_resource_name_prefix"></a> [resource\_name\_prefix](#input\_resource\_name\_prefix) | Resource name prefix, used in role name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | Lambda function ARNs in key/value map |
| <a name="output_lambda_name"></a> [lambda\_name](#output\_lambda\_name) | Lambda function names in key/value map |
<!-- END_TF_DOCS -->