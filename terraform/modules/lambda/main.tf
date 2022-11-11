#######################################
# lambda_function
#######################################
module "lambda_function" {
  source   = "terraform-aws-modules/lambda/aws"
  for_each = var.lambda_functions

  function_name       = each.key
  runtime             = each.value.runtime
  handler             = each.value.handler
  create_package      = false
  s3_existing_package = {
    bucket = var.s3_bucket_name
    key    = var.s3_object_key
  }

  create_current_version_allowed_triggers = false

  environment_variables = {
    SPRING_CLOUD_FUNCTION_DEFINITION = each.value.function_name_variable
  }
  ephemeral_storage_size = each.value.ephemeral_storage
  memory_size            = each.value.memory_size
  package_type           = "Zip"
  timeout                = "15"
}
