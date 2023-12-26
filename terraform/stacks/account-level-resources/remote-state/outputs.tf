output "remote_state_s3" {
  description = "Remote state S3 bucket name"
  value       = aws_s3_bucket.remote_state_bucket
}
