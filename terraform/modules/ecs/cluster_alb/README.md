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
| [aws_alb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.ecs_alb_target_group](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/alb_target_group) | resource |
| [aws_ecs_cluster.ecs_fargate](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.fargate_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_lb.ecs_alb](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/lb) | resource |
| [aws_lb_listener_rule.ag_alb_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/lb_listener_rule) | resource |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/security_group) | resource |
| [github_actions_environment_variable.ecs_cluster](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/actions_environment_variable) | resource |
| [aws_ssm_parameter.public_subnet_a_id](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.public_subnet_b_id](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.public_subnet_c_id](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.vpc_id](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_https_certificate_arn"></a> [alb\_https\_certificate\_arn](#input\_alb\_https\_certificate\_arn) | ALB HTTPS certification arn | `string` | `""` | no |
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | The name of the loadbalancer | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster (up to 255 letters, numbers, hyphens, and underscores) | `string` | n/a | yes |
| <a name="input_context_path"></a> [context\_path](#input\_context\_path) | application's context path, used for ALB listener rule configuration | `string` | `""` | no |
| <a name="input_create_cluster"></a> [create\_cluster](#input\_create\_cluster) | flag to create new cluster or use existing one | `bool` | `true` | no |
| <a name="input_deploy_env"></a> [deploy\_env](#input\_deploy\_env) | Deployment environment passed in from CI workflow | `string` | `"dev"` | no |
| <a name="input_deploy_repo"></a> [deploy\_repo](#input\_deploy\_repo) | GitHub repo passed in from CI workflow | `string` | `""` | no |
| <a name="input_github_repo_owner"></a> [github\_repo\_owner](#input\_github\_repo\_owner) | GitHub repo owner | `string` | n/a | yes |
| <a name="input_healthcheck_path"></a> [healthcheck\_path](#input\_healthcheck\_path) | application's health check path | `string` | `""` | no |
| <a name="input_pipeline_token"></a> [pipeline\_token](#input\_pipeline\_token) | GitHub token passed in from CI workflow | `string` | `""` | no |
| <a name="input_requester_name"></a> [requester\_name](#input\_requester\_name) | requester name tag | `string` | n/a | yes |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | application's service port | `string` | `"443"` | no |
| <a name="input_service_port_target_group"></a> [service\_port\_target\_group](#input\_service\_port\_target\_group) | application's service port | `string` | `"8080"` | no |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | The name of the target group | `string` | `"default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_security_group_id"></a> [alb\_security\_group\_id](#output\_alb\_security\_group\_id) | n/a |
| <a name="output_ecs_alb_target_group_arn"></a> [ecs\_alb\_target\_group\_arn](#output\_ecs\_alb\_target\_group\_arn) | n/a |
| <a name="output_ecs_alb_target_group_name"></a> [ecs\_alb\_target\_group\_name](#output\_ecs\_alb\_target\_group\_name) | n/a |
| <a name="output_ecs_cluster"></a> [ecs\_cluster](#output\_ecs\_cluster) | n/a |
<!-- END_TF_DOCS -->