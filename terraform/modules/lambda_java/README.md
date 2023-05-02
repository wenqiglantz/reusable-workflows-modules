<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [random_string.random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.simple_lambda_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key | `string` | `""` | no |
| <a name="input_lambda_archive_path"></a> [lambda\_archive\_path](#input\_lambda\_archive\_path) | Lambda code archive path | `string` | `""` | no |
| <a name="input_lambda_code_file"></a> [lambda\_code\_file](#input\_lambda\_code\_file) | Lambda code jar file | `string` | `""` | no |
| <a name="input_lambda_function"></a> [lambda\_function](#input\_lambda\_function) | Lambda function details | `map(any)` | <pre>{<br>  "ephemeral_storage": "512",<br>  "function_name": "chat",<br>  "function_name_variable": "chat",<br>  "handler": "org.springframework.cloud.function.adapter.aws.FunctionInvoker",<br>  "memory_size": "128",<br>  "runtime": "java17",<br>  "timeout": "15"<br>}</pre> | no |
| <a name="input_lambda_log_retention_in_days"></a> [lambda\_log\_retention\_in\_days](#input\_lambda\_log\_retention\_in\_days) | Log retention in days | `number` | `7` | no |
| <a name="input_resource_name_prefix"></a> [resource\_name\_prefix](#input\_resource\_name\_prefix) | Resource name prefix, used in role name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | Lambda function ARN |
| <a name="output_lambda_name"></a> [lambda\_name](#output\_lambda\_name) | Lambda function name |
| <a name="output_qualified_arn"></a> [qualified\_arn](#output\_qualified\_arn) | ARN identifying your Lambda Function Version (if versioning is enabled via publish = true) |
| <a name="output_qualified_invoke_arn"></a> [qualified\_invoke\_arn](#output\_qualified\_invoke\_arn) | Qualified ARN (ARN with lambda version number) to be used for invoking Lambda Function from API Gateway - to be used in aws\_api\_gateway\_integration's uri |
<!-- END_TF_DOCS -->