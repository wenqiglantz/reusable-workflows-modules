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

data "aws_ssm_parameter" "public_subnet_0_id" {
  name = "/base/publicSubnet0"
}

data "aws_ssm_parameter" "public_subnet_1_id" {
  name = "/base/publicSubnet1"
}

data "aws_ssm_parameter" "public_subnet_2_id" {
  name = "/base/publicSubnet2"
}

#######################################
# aws_ecs_cluster
#######################################
resource "aws_ecs_cluster" "ecs_fargate" {
  count = var.create_cluster ? 1 : 0
  name  = var.cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "fargate_capacity_provider" {
  count              = var.create_cluster ? 1 : 0
  cluster_name       = aws_ecs_cluster.ecs_fargate[0].name
  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = "0"
    capacity_provider = "FARGATE_SPOT"
    weight            = "1"
  }
}

#######################################
# aws_security_group for ALB
#######################################
resource "aws_security_group" "alb_sg" {
  count  = var.create_cluster ? 1 : 0
  name   = var.alb_name
  #description = "security group for ALB"
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description      = "ingress for tcp port"
    from_port        = var.service_port
    to_port          = var.service_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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
# aws_alb
#######################################
resource "aws_lb" "ecs_alb" {
  count              = var.create_cluster ? 1 : 0
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg[0].id]
  subnets            = [
    data.aws_ssm_parameter.public_subnet_0_id.value,
    data.aws_ssm_parameter.public_subnet_1_id.value,
    data.aws_ssm_parameter.public_subnet_2_id.value
  ]
  drop_invalid_header_fields = true
}

#resource "aws_alb_target_group" "ecs_alb_target_group" {
#  count                         = var.create_cluster ? 1 : 0
#  name                          = var.target_group_name
#  port                          = var.service_port_target_group
#  protocol                      = "HTTP"
#  vpc_id                        = data.aws_ssm_parameter.vpc_id.value
#  target_type                   = "ip"
#  load_balancing_algorithm_type = "least_outstanding_requests"
#
#  health_check {
#    healthy_threshold   = "2"
#    unhealthy_threshold = "5"
#    interval            = "30"
#    protocol            = "HTTP"
#    matcher             = "200-399"
#    path                = var.healthcheck_path
#    timeout             = "10"
#  }
#}

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
# GitHub env variable creation, need this variable for app CI/CD in github actions
#######################################
resource "github_actions_environment_variable" "ecs_cluster" {
  repository    = var.deploy_repo
  environment   = var.deploy_env
  variable_name = "ECS_CLUSTER"
  value         = aws_ecs_cluster.ecs_fargate[0].name
}