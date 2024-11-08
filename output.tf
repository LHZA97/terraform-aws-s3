output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket_resource.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket_resource.arn
}

output "bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = aws_s3_bucket.s3_bucket_resource.bucket_domain_name
}

output "bucket_location" {
  description = "The region where the S3 bucket is created"
  value       = aws_s3_bucket.s3_bucket_resource.region
}

output "bucket_versioning_status" {
  description = "The versioning status of the S3 bucket"
  value       = aws_s3_bucket_versioning.s3_bucket_versioning_resource.versioning_configuration[0].status
}

# output "bucket_logging_target" {
#   description = "The target bucket for logging, if logging is enabled"
#   value       = aws_s3_bucket_logging.s3_bucket_logging_resource.target_bucket
# }

output "bucket_tags" {
  description = "Tags applied to the S3 bucket"
  value       = aws_s3_bucket.s3_bucket_resource.tags
}

output "public_access_block" {
  description = "The public access block settings for the S3 bucket"
  value       = aws_s3_bucket_public_access_block.s3_block_public_access_resource
}