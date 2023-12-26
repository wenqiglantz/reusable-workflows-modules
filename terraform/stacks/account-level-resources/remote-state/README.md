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
| [aws_dynamodb_table.terraform_state_lock](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.remote_state_bucket](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.remote_state_bucket_logging](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_logging.remote_state_bucket](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_public_access_block.remote_state_bucket](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.remote_state_bucket_logging](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.remote_state_bucket](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.remote_state_bucket](https://registry.terraform.io/providers/hashicorp/aws/5.31.0/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_deploy_env"></a> [deploy\_env](#input\_deploy\_env) | Deployment environment passed in from CI workflow | `string` | `"dev"` | no |
| <a name="input_requester_name"></a> [requester\_name](#input\_requester\_name) | requester name tag | `string` | n/a | yes |
| <a name="input_s3_bucket_remote_state"></a> [s3\_bucket\_remote\_state](#input\_s3\_bucket\_remote\_state) | S3 bucket name for Terraform remote state management | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_remote_state_s3"></a> [remote\_state\_s3](#output\_remote\_state\_s3) | Remote state S3 bucket name |
<!-- END_TF_DOCS -->