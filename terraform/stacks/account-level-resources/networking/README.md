<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.31.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_networking"></a> [networking](#module\_networking) | github.com/wenqiglantz/reusable-workflows-modules//terraform/modules/networking | main |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | flag to create new VPC or use existing one | `bool` | `true` | no |
| <a name="input_deploy_env"></a> [deploy\_env](#input\_deploy\_env) | CI injected variable, deployment environment | `string` | `"dev"` | no |
| <a name="input_private_subnets_cidr"></a> [private\_subnets\_cidr](#input\_private\_subnets\_cidr) | The CIDR block for the private subnet | `list` | n/a | yes |
| <a name="input_public_subnets_cidr"></a> [public\_subnets\_cidr](#input\_public\_subnets\_cidr) | The CIDR block for the public subnet | `list` | n/a | yes |
| <a name="input_requester_name"></a> [requester\_name](#input\_requester\_name) | requestor name tag | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR block of the vpc | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_sg_id"></a> [default\_sg\_id](#output\_default\_sg\_id) | n/a |
| <a name="output_private_subnets_id"></a> [private\_subnets\_id](#output\_private\_subnets\_id) | n/a |
| <a name="output_public_route_table"></a> [public\_route\_table](#output\_public\_route\_table) | n/a |
| <a name="output_public_subnets_id"></a> [public\_subnets\_id](#output\_public\_subnets\_id) | n/a |
| <a name="output_security_groups_ids"></a> [security\_groups\_ids](#output\_security\_groups\_ids) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END_TF_DOCS -->