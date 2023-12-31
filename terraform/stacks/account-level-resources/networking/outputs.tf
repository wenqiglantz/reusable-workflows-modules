output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnets_id" {
  value = module.networking.public_subnets_id
}

output "private_subnets_id" {
  value = module.networking.private_subnets_id
}

output "default_sg_id" {
  value = module.networking.default_sg_id
}

output "security_groups_ids" {
  value = module.networking.security_groups_ids
}

output "public_route_table" {
  value = module.networking.public_route_table
}