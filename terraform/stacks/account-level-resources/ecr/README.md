<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.31.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.my_ecr_lifecycle_policy](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.my_ecr_repo](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.my_ecr_repo_policy](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/ecr_repository_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for all resources. | `string` | n/a | yes |
| <a name="input_deploy_env"></a> [deploy\_env](#input\_deploy\_env) | Deployment environment passed in from CI workflow | `string` | `"dev"` | no |
| <a name="input_ecr_repo_name"></a> [ecr\_repo\_name](#input\_ecr\_repo\_name) | ECR repo name | `string` | n/a | yes |
| <a name="input_lifecycle_days_count"></a> [lifecycle\_days\_count](#input\_lifecycle\_days\_count) | The number of days the images remain in ECR before they expire | `number` | `30` | no |
| <a name="input_lifecycle_tag_status"></a> [lifecycle\_tag\_status](#input\_lifecycle\_tag\_status) | Lifecycle tag status | `string` | `"any"` | no |
| <a name="input_requester_name"></a> [requester\_name](#input\_requester\_name) | requester name tag | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_repo_id"></a> [ecr\_repo\_id](#output\_ecr\_repo\_id) | ECR repo ID |
<!-- END_TF_DOCS -->