output "ecr_repo_id" {
  description = "ECR repo ID"
  value       = aws_ecr_repository.my_ecr_repo.id
}
