<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.31.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 5.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.31.0 |
| <a name="provider_github"></a> [github](#provider\_github) | 5.42.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.app](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_service.app](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.app](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.task_execution_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.task_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.fargate_task](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/security_group) | resource |
| [aws_service_discovery_private_dns_namespace.app](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/service_discovery_private_dns_namespace) | resource |
| [aws_service_discovery_service.app_service](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/service_discovery_service) | resource |
| [aws_ssm_parameter.entry](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/ssm_parameter) | resource |
| [github_actions_environment_secret.container_name](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.ecs_service](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.ecs_task_definition](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/actions_environment_secret) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.task_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.task_policy](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.fargate-role-policy](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_security_group_id"></a> [alb\_security\_group\_id](#input\_alb\_security\_group\_id) | The ALB security group id | `string` | `"default"` | no |
| <a name="input_alb_target_group_arn"></a> [alb\_target\_group\_arn](#input\_alb\_target\_group\_arn) | The ARN of the ALB target group | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster (up to 255 letters, numbers, hyphens, and underscores) | `string` | `""` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The CPU size | `number` | `512` | no |
| <a name="input_cpu_architecture"></a> [cpu\_architecture](#input\_cpu\_architecture) | ECS task definition's CPU architecture, either X86\_64 or ARM64 | `string` | `"X86_64"` | no |
| <a name="input_deploy_env"></a> [deploy\_env](#input\_deploy\_env) | Deployment environment passed in from CI workflow | `string` | `"dev"` | no |
| <a name="input_deploy_repo"></a> [deploy\_repo](#input\_deploy\_repo) | GitHub repo passed in from CI workflow | `string` | `""` | no |
| <a name="input_ecr_repository_name"></a> [ecr\_repository\_name](#input\_ecr\_repository\_name) | The ECR repository name | `string` | `"default"` | no |
| <a name="input_ecs_service_sg_name"></a> [ecs\_service\_sg\_name](#input\_ecs\_service\_sg\_name) | The name of the ECS service security group | `string` | `"default"` | no |
| <a name="input_github_repo_owner"></a> [github\_repo\_owner](#input\_github\_repo\_owner) | GitHub repo owner | `string` | n/a | yes |
| <a name="input_log_group_retention_in_days"></a> [log\_group\_retention\_in\_days](#input\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, etc. | `number` | `7` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The memory size | `number` | `1024` | no |
| <a name="input_operating_system_family"></a> [operating\_system\_family](#input\_operating\_system\_family) | ECS task definition's operating system family, such as LINUX, WINDOWS\_SERVER\_2019\_FULL, etc. | `string` | `"LINUX"` | no |
| <a name="input_parameter_store_entries"></a> [parameter\_store\_entries](#input\_parameter\_store\_entries) | Map of parameter store entries, if no param store needed, leave as empty | `map(any)` | `{}` | no |
| <a name="input_pipeline_token"></a> [pipeline\_token](#input\_pipeline\_token) | GitHub token passed in from CI workflow | `string` | `""` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet ids | `list` | n/a | yes |
| <a name="input_requester_name"></a> [requester\_name](#input\_requester\_name) | requester name tag | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | service name, the same as the ECR image name | `string` | n/a | yes |
| <a name="input_service_port_target_group"></a> [service\_port\_target\_group](#input\_service\_port\_target\_group) | application's service port | `number` | `8080` | no |
| <a name="input_use_existing_cloudwatch_log_group"></a> [use\_existing\_cloudwatch\_log\_group](#input\_use\_existing\_cloudwatch\_log\_group) | flag to indicate whether or not to use existing cloudwatch log group | `bool` | `true` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The VPC cidr block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_test"></a> [app\_test](#output\_app\_test) | n/a |
| <a name="output_container_name"></a> [container\_name](#output\_container\_name) | n/a |
| <a name="output_ecr_repository_name"></a> [ecr\_repository\_name](#output\_ecr\_repository\_name) | n/a |
| <a name="output_ecs_cluster"></a> [ecs\_cluster](#output\_ecs\_cluster) | n/a |
| <a name="output_ecs_service"></a> [ecs\_service](#output\_ecs\_service) | n/a |
| <a name="output_ecs_task_definition"></a> [ecs\_task\_definition](#output\_ecs\_task\_definition) | n/a |
| <a name="output_fargate_task_security_group_id"></a> [fargate\_task\_security\_group\_id](#output\_fargate\_task\_security\_group\_id) | n/a |
<!-- END_TF_DOCS -->