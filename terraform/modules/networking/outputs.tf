output "vpc_id" {
  value = aws_vpc.vpc[0].id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnet[*].id
}

output "default_sg_id" {
  value = aws_security_group.default[0].id
}

output "security_groups_ids" {
  value = [aws_security_group.default[0].id]
}

output "public_route_table" {
  value = aws_route_table.public[0].id
}