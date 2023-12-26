output "ecs_cluster" {
  value = aws_ecs_cluster.ecs_fargate[0].name
}

output "ecs_alb_target_group_name" {
  value = aws_alb_target_group.ecs_alb_target_group[0].name
}

output "ecs_alb_target_group_arn" {
  value = aws_alb_target_group.ecs_alb_target_group[0].arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg[0].id
}
