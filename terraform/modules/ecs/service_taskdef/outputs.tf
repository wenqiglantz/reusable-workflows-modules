output "ecs_cluster" {
  value = var.cluster_name
}

output "ecs_service" {
  value = aws_ecs_service.app.name
}

output "ecs_task_definition" {
  value = aws_ecs_task_definition.app.family
}

output "container_name" {
  value = var.service_name
}

output "ecr_repository_name" {
  value = var.ecr_repository_name
}

output "app_test" {
  value = "curl http://${aws_ecs_service.app.name}.${aws_service_discovery_private_dns_namespace.app.name}"
}

output "fargate_task_security_group_id" {
  value = aws_security_group.fargate_task.id
}
