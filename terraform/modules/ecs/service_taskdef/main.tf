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

#######################################
# VPC/subnets/certificate retrieved from parameter store
#######################################
data "aws_ssm_parameter" "vpc_id" {
  name = "/base/vpcId"
}

data "aws_ssm_parameter" "private_subnet_0_id" {
  name = "/base/privateSubnet0"
}

data "aws_ssm_parameter" "private_subnet_1_id" {
  name = "/base/privateSubnet1"
}

data "aws_ssm_parameter" "private_subnet_2_id" {
  name = "/base/privateSubnet2"
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
  cw_log_group = "/ecs/${local.service_name}"
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
  name   = "${local.service_name}-fargate-task"
  #description = "security group for fargate task"
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description     = "ingress for ALB security group"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.alb_security_group_id]
  }
  egress {
    description      = "egress rule"
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
    security_groups = [aws_security_group.fargate_task.id]
    subnets         = [
      data.aws_ssm_parameter.private_subnet_0_id.value,
      data.aws_ssm_parameter.private_subnet_1_id.value,
      data.aws_ssm_parameter.private_subnet_2_id.value
    ]
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
  vpc         = data.aws_ssm_parameter.vpc_id.value
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
# GitHub env variable creation, need these variables for app CI/CD in github actions
#######################################
resource "github_actions_environment_variable" "ecs_task_definition" {
  repository    = var.deploy_repo
  environment   = var.deploy_env
  variable_name = "ECS_TASK_DEFINITION"
  value         = aws_ecs_task_definition.app.family
}

resource "github_actions_environment_variable" "container_name" {
  repository    = var.deploy_repo
  environment   = var.deploy_env
  variable_name = "CONTAINER_NAME"
  value         = aws_ecs_task_definition.app.family
}

resource "github_actions_environment_variable" "ecs_service" {
  repository    = var.deploy_repo
  environment   = var.deploy_env
  variable_name = "ECS_SERVICE"
  value         = aws_ecs_service.app.name
}

resource "github_actions_environment_variable" "ecr_repository_name" {
  repository    = var.deploy_repo
  environment   = var.deploy_env
  variable_name = "ECR_REPOSITORY_NAME"
  value         = var.ecr_repository_name
}

#######################################
# aws_alb_target_group
#######################################
resource "aws_alb_target_group" "ecs_alb_target_group" {
  count                         = var.create_cluster ? 1 : 0
  name                          = var.target_group_name
  port                          = local.service_port
  protocol                      = "HTTP"
  vpc_id                        = data.aws_ssm_parameter.vpc_id.value
  target_type                   = "ip"
  load_balancing_algorithm_type = "least_outstanding_requests"

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "5"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200-399"
    path                = var.healthcheck_path
    timeout             = "10"
  }
}

resource "aws_alb_listener" "https" {
  count             = var.create_cluster ? 1 : 0
  load_balancer_arn = aws_lb.ecs_alb[0].id
  port              = var.service_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.alb_https_certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.ecs_alb_target_group[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "ag_alb_listener_rule" {
  count        = var.create_cluster ? 1 : 0
  listener_arn = aws_alb_listener.https[0].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_alb_target_group[0].arn
  }
  condition {
    path_pattern {
      values = [
        join("", ["/", var.context_path]),
        join("", ["/", var.context_path, "/"]),
        join("", ["/", var.context_path, "/*"])
      ]
    }
  }
}

#######################################
# aws_iam_role for auto scale
#######################################
resource "aws_iam_role" "ecs_autoscale_role" {
  name = "${var.service_name}-ecs-service-autoscale"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_autoscale" {
  role       = aws_iam_role.ecs_autoscale_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

#######################################
# aws_appautoscaling_target
#######################################
resource "aws_appautoscaling_target" "ecs_service_target" {
  max_capacity       = var.ecs_autoscaling_target_max_capacity
  min_capacity       = var.ecs_autoscaling_target_min_capacity
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs_autoscale_role.arn
}

#######################################
# aws_appautoscaling_policy
#######################################
resource "aws_appautoscaling_policy" "ecs_autoscaling_policy" {
  name               = "${var.service_name}-app-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      # https://github.com/hashicorp/terraform-provider-aws/issues/9734
      resource_label         = "${var.alb_arn_suffix}/${aws_alb_target_group.ecs_alb_target_group.arn_suffix}"
    }
    target_value = var.alb_request_count_per_target
  }
  depends_on = [
    aws_appautoscaling_target.ecs_service_target,
    aws_ecs_service.app
  ]
}
