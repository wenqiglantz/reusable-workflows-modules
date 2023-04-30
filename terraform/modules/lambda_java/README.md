# Terraform Lambda_nodejs composite module

Terraform module for serverless workloads using Lambda 

## Features

* Deploys your serverless app to one or multiple Lambda functions


## Usage

In the terraform root `main.tf`, we call lambda_nodejs composite module, see snippet below.  The variables are passed in from their corresponding env's `terraform.tfvars` file.  Sample terraform root `main.tf`:

```
module "lambda" {
  source                       = "github.com/arisglobal/sharedactions/terraform/modules/lambda_nodejs"
  resource_name_prefix         = var.resource_name_prefix
  lambda_code_path             = "${path.root}/${var.lambda_code_path}"
  lambda_archive_path          = "${path.root}/${var.lambda_archive_path}"
  lambda_log_retention_in_days = var.lambda_log_retention_in_days
  lambda_functions             = var.lambda_functions
}
```


### Sample terraform.tfvars:

The `terraform.tfvars` file should be located under the `terraform\phantom\.env` directory corresponding to the environment the variables are defined for.

See below the sample snippet of `terraform.tfvars` for dev.  Variable for `lambda_functions` map can contain zero or multiple Lambda functions.
```
aws_region                   = "us-east-1"
resource_name_prefix         = "phantom-lambda"
lambda_code_path             = "../../phantom-lambda" #code path, relative to terraform project path
lambda_archive_path          = "../../phantom-lambda.zip" #zip file path, relative to terraform project path
lambda_log_retention_in_days = 30

lambda_functions = {
  phantom-lambda = {
    runtime                      = "nodejs16.x"
    handler                      = "index.handler"
    ephemeral_storage            = 512
    memory_size                  = 128
    timeout                      = 15
    lambda_concurrent_executions = -1
    # for Lambda function which does not have environment variables, simply set "environment_variables = null" to replace the block below
    environment_variables        = {
      CLIENT_ID     = "#####"
      CLIENT_SECRET = "###########"
      AUDIENCE      = "###########"
      GRANT_TYPE    = "client_credentials"
      TOKEN_URL     = "###########"
      TOKEN_PATH    = "/oauth/token"
      SPLIT_URL     = "###########"
      SPLIT_PATH    = "###########"
    }
  }
}
```

## GitHub actions workflow for Terraform

The only GitHub environment secret needed to run terraform workflow is `TERRAFORM_ROLE_TO_ASSUME`, for example, for AGSHAREDSERVICES-DEV account, it points to MasterAutomationRole which has OIDC integrated and has admin access policies for that account. `AWS_REGION` is already configured at GitHub organization level, so no need to configure secret for it again.

A reusable GitHub Actions workflow for Terraform deployment has been extracted into SharedActions repo, https://github.com/ArisGlobal/SharedActions/blob/latest/.github/workflows/terraform.yml. Your app’s workflow to deploy Terraform files should be calling this Terraform reusable workflow.  Sample `terraform-phantom.yml` from phantom-lambda that calls Terraform reusable workflow:

```
name: "Terraform Deployment for phantom-lambda"

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to run the workflow against'
        type: environment
        required: true

jobs:

  infracost:
    permissions:
      contents: write
      pull-requests: write
    uses: ArisGlobal/SharedActions/.github/workflows/terraform-infracost.yml@latest
    with:
      # need to specify working-directory as that's where the terraform files live in the source code
      working-directory: ./terraform/phantom
      terraform-var-file: ./.env/${{ github.event.inputs.environment || 'poc' }}/terraform.tfvars #TODO change to dev default
      usage-file: ./.env/${{ github.event.inputs.environment || 'poc' }}/infracost-usage.yml #TODO change to dev default
      infracost-flag: true # run infracost analysis
    secrets: inherit

  terraform:
    needs: infracost
    permissions:
      id-token: write  # need this for OIDC
      contents: read   # This is required for actions/checkout@v2
    uses: ArisGlobal/SharedActions/.github/workflows/terraform.yml@latest
    with:
      # need to specify working-directory as that's where the terraform files live in the source code
      working-directory: ./terraform/phantom
    secrets: inherit
```

Run from your project by kicking off the `terraform-phantom.yml` github actions workflow.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.45.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.45.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/4.45.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/4.45.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_dynamodb](https://registry.terraform.io/providers/hashicorp/aws/4.45.0/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/4.45.0/docs/resources/lambda_function) | resource |
| [random_string.random_string](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/string) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.simple_lambda_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/4.45.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for all resources. | `string` | `""` | no |
| <a name="input_customer_name"></a> [customer\_name](#input\_customer\_name) | customer name tag | `string` | `"epd"` | no |
| <a name="input_deploy_env"></a> [deploy\_env](#input\_deploy\_env) | Deployment environment passed in from CI workflow | `string` | `"dev"` | no |
| <a name="input_jira_id"></a> [jira\_id](#input\_jira\_id) | jira ticket id tag | `string` | `""` | no |
| <a name="input_lambda_archive_path"></a> [lambda\_archive\_path](#input\_lambda\_archive\_path) | Lambda code archive path | `string` | `""` | no |
| <a name="input_lambda_code_path"></a> [lambda\_code\_path](#input\_lambda\_code\_path) | Lambda code path | `string` | `""` | no |
| <a name="input_lambda_excludes"></a> [lambda\_excludes](#input\_lambda\_excludes) | Files to exclude from deployment | `list` | `[]` | no |
| <a name="input_lambda_functions"></a> [lambda\_functions](#input\_lambda\_functions) | Map of Lambda function details | `map(any)` | <pre>{<br>  "function_name": {<br>    "description": "function description",<br>    "environment_variables": null,<br>    "ephemeral_storage": "512",<br>    "handler": "index.handler",<br>    "lambda_concurrent_executions": -1,<br>    "memory_size": "128",<br>    "runtime": "nodejs16.x",<br>    "timeout": 15<br>  }<br>}</pre> | no |
| <a name="input_lambda_log_retention_in_days"></a> [lambda\_log\_retention\_in\_days](#input\_lambda\_log\_retention\_in\_days) | Log retention in days | `number` | `7` | no |
| <a name="input_map_code"></a> [map\_code](#input\_map\_code) | map-migrated tag | `string` | `"mig47572"` | no |
| <a name="input_product"></a> [product](#input\_product) | project name tag | `string` | `"plat"` | no |
| <a name="input_product_version"></a> [product\_version](#input\_product\_version) | product version tag | `string` | `"plat2023.1.0.0"` | no |
| <a name="input_requestor_name"></a> [requestor\_name](#input\_requestor\_name) | requestor name tag | `string` | `""` | no |
| <a name="input_resource_name_prefix"></a> [resource\_name\_prefix](#input\_resource\_name\_prefix) | Resource name prefix, used in role name | `string` | `""` | no |
| <a name="input_revenue_type"></a> [revenue\_type](#input\_revenue\_type) | revenue type tag | `string` | `"non-rev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | Lambda function ARNs in key/value map |
| <a name="output_lambda_name"></a> [lambda\_name](#output\_lambda\_name) | Lambda function names in key/value map |
<!-- END_TF_DOCS -->