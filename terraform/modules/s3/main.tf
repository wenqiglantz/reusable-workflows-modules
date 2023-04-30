//using archive_file data source to zip the lambda code:
data "archive_file" "lambda_code" {
  type        = "zip"
  source_file  = "${path.module}/${var.lambda_jar_relative_path}"
  output_path = "${path.module}/${var.s3_object_key}"
}

#######################################
# create S3 bucket to upload the zip
#######################################
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "static_site" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = var.s3_object_key
  source = data.archive_file.lambda_code.output_path
  etag   = filemd5(data.archive_file.lambda_code.output_path)
}
