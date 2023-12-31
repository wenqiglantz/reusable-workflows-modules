#######################################
# Provider
#######################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
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

locals {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
}

#######################################
# aws_vpc
#######################################
resource "aws_vpc" "vpc" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_security_group" "default" {
  count       = var.create_vpc ? 1 : 0
  name        = "${var.deploy_env}-default-sg"
  description = "Default security group for the VPC"
  vpc_id      = aws_vpc.vpc[0].id
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
}

#######################################
# public subnet
#######################################
resource "aws_subnet" "public_subnet" {
  count                   = var.create_vpc && length(var.public_subnets_cidr) > 0 ? length(var.public_subnets_cidr) : 0
  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "ig" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id
}

resource "aws_eip" "nat_eip" {
  count      = var.create_vpc ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.ig]
}

resource "aws_route_table" "public" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id
}

resource "aws_route" "public_internet_gateway" {
  count                  = var.create_vpc ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig[0].id
}

resource "aws_route_table_association" "public" {
  count          = var.create_vpc && length(var.public_subnets_cidr) > 0 ? length(var.public_subnets_cidr) : 0
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

#######################################
# private subnet
#######################################
resource "aws_subnet" "private_subnet" {
  count                   = var.create_vpc && length(var.private_subnets_cidr) > 0 ? length(var.private_subnets_cidr) : 0
  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(local.availability_zones, count.index)
  map_public_ip_on_launch = false
}

resource "aws_nat_gateway" "nat" {
  count         = var.create_vpc ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = element(aws_subnet.public_subnet[*].id, 0)
  depends_on    = [aws_internet_gateway.ig]
}

resource "aws_route_table" "private" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id
}

resource "aws_route" "private_nat_gateway" {
  count                  = var.create_vpc ? 1 : 0
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "private" {
  count          = var.create_vpc && length(var.private_subnets_cidr) > 0 ? length(var.private_subnets_cidr) : 0
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private[0].id
}

#######################################
# persist vpc/subnets in parameter store
#######################################
resource "aws_ssm_parameter" "vpc_id" {
  count = var.create_vpc ? 1 : 0
  name  = "/base/vpcId"
  type  = "String"
  value = aws_vpc.vpc[0].id
}

resource "aws_ssm_parameter" "public_subnet_id" {
  count = var.create_vpc ? length(aws_subnet.public_subnet) : 0
  name  = "/base/publicSubnet${count.index}"
  type  = "String"
  value = aws_subnet.public_subnet[count.index].id
}

resource "aws_ssm_parameter" "private_subnet_id" {
  count = var.create_vpc ? length(aws_subnet.private_subnet) : 0
  name  = "/base/privateSubnet${count.index}"
  type  = "String"
  value = aws_subnet.private_subnet[count.index].id
}
