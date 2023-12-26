#######################################
# Provider
#######################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.42.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # default tags per https://registry.terraform.io/providers/hashicorp/aws/latest/docs#default_tags-configuration-block
  default_tags {
    tags = {
      requester = var.requester_name
      env       = var.deploy_env
      ManagedBy = "Terraform"
    }
  }
}

# for github secrets creation
provider "github" {
  token = var.pipeline_token
  owner = var.github_repo_owner
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  aws_account_id       = data.aws_caller_identity.current.account_id
  service_name         = var.service_name
  ecr_repository_name  = var.ecr_repository_name
  task_image           = "${local.aws_account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.ecr_repository_name}:latest"
  service_port         = var.service_port_target_group
  service_namespace_id = aws_service_discovery_private_dns_namespace.app.id
  container_definition = [
    {
      cpu                     = var.cpu
      image                   = local.task_image
      memory                  = var.memory
      name                    = local.service_name
      networkMode             = "awsvpc"
      operating_system_family = var.operating_system_family
      cpu_architecture        = var.cpu_architecture
      environment             = [
        {
          "name" : "SERVICE_DISCOVERY_NAMESPACE_ID", "value" : local.service_namespace_id
        }
      ]
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = local.service_port
          hostPort      = local.service_port
        }
      ]
      logConfiguration = {
        logdriver = "awslogs"
        options   = {
          "awslogs-group"         = local.cw_log_group
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "stdout"
        }
      }
    }
  ]
  cw_log_group        = "/ecs/${local.service_name}"
}

#######################################
# aws_iam_role
#######################################
data "aws_iam_policy_document" "fargate-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}

# using data block to query policy resources for task_execution_policy details
data "aws_iam_policy" "task_execution_policy" {
  name = "task_execution_policy"
}

# using data block to query policy resources for task_policy details
data "aws_iam_policy" "task_policy" {
  name = "task_policy"
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${local.service_name}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.fargate-role-policy.json
}

resource "aws_iam_role" "task_role" {
  name               = "${local.service_name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.fargate-role-policy.json
}

resource "aws_iam_role_policy_attachment" "task_execution_role_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = data.aws_iam_policy.task_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "task_role_attachment" {
  role       = aws_iam_role.task_role.name
  policy_arn = data.aws_iam_policy.task_policy.arn
}

#######################################
# aws_security_group
#######################################
resource "aws_security_group" "fargate_task" {
  name        = "${local.service_name}-fargate-task"
  #description = "security group for fargate task"
  vpc_id      = var.vpc_id

  ingress {
    description = "ingress for ALB security group"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.alb_security_group_id]
  }
  egress {
    description = "egress rule"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    # Necessary if changing 'name' or 'name_prefix' properties.
    create_before_destroy = true
  }
}

#######################################
# aws_cloudwatch_log_group
#######################################
resource "aws_cloudwatch_log_group" "app" {
  name              = local.cw_log_group
  retention_in_days = var.log_group_retention_in_days
}

#######################################
# aws_ecs_task_definition
#######################################
resource "aws_ecs_task_definition" "app" {
  family                   = local.service_name
  network_mode             = "awsvpc"
  cpu                      = local.container_definition[0].cpu
  memory                   = local.container_definition[0].memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = jsonencode(local.container_definition)
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  runtime_platform {
    operating_system_family = local.container_definition[0].operating_system_family
    cpu_architecture        = local.container_definition[0].cpu_architecture
  }
}

#######################################
# aws_ecs_service
#######################################
resource "aws_ecs_service" "app" {
  name                               = local.service_name
  cluster                            = var.cluster_name
  task_definition                    = aws_ecs_task_definition.app.arn
  desired_count                      = "1"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  platform_version                   = "1.4.0"
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  enable_ecs_managed_tags            = "false"
  enable_execute_command             = "true"
  health_check_grace_period_seconds  = "600"
  propagate_tags                     = "SERVICE"

  deployment_circuit_breaker {
    enable   = "true"
    rollback = "false"
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.app_service.arn
    container_name = local.service_name
    container_port = local.service_port
  }

  network_configuration {
    security_groups  = [aws_security_group.fargate_task.id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = local.service_name
    container_port   = local.service_port
  }
}

#######################################
# aws_service_discovery_service
#######################################
resource "aws_service_discovery_service" "app_service" {
  name = local.service_name

  dns_config {
    namespace_id = local.service_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    dns_records {
      ttl  = 10
      type = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_private_dns_namespace" "app" {
  name        = "${local.service_name}.agcloud.bz"
  description = "${local.service_name}.agcloud.bz zone"
  vpc         = var.vpc_id
}

#######################################
# aws_ssm_parameter
#######################################
resource "aws_ssm_parameter" "entry" {
  for_each = var.parameter_store_entries
  name     = each.value.key
  type     = each.value.type
  value    = each.value.value
}

#######################################
# GitHub secrets creation, need these secrets for app CI/CD in github actions
# plaintext_value is allowed per https://github.com/bridgecrewio/checkov/pull/2383/files
#######################################
resource "github_actions_environment_secret" "ecs_task_definition" {
  repository      = var.deploy_repo
  environment     = var.deploy_env
  secret_name     = "ECS_TASK_DEFINITION"
  plaintext_value = aws_ecs_task_definition.app.family
}

resource "github_actions_environment_secret" "container_name" {
  repository      = var.deploy_repo
  environment     = var.deploy_env
  secret_name     = "CONTAINER_NAME"
  plaintext_value = aws_ecs_task_definition.app.family
}

resource "github_actions_environment_secret" "ecs_service" {
  repository      = var.deploy_repo
  environment     = var.deploy_env
  secret_name     = "ECS_SERVICE"
  plaintext_value = aws_ecs_service.app.name
}
