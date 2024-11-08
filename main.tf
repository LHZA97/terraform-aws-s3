data "aws_partition" "current" {}

resource "aws_s3_bucket" "s3_bucket_resource" {
      bucket                        = var.bucket_name
      force_destroy                 = var.force_destroy
      object_lock_enabled           = var.object_lock_enabled
      tags                          = var.tags
}

# resource "aws_s3_bucket_logging" "s3_bucket_logging_resource" {
#       bucket                        = aws_s3_bucket.s3_bucket_resource.id
#       target_bucket                 = var.target_bucket
#       target_prefix                 = var.target_prefix
# }

resource "aws_s3_bucket_versioning" "s3_bucket_versioning_resource" {
      bucket                        = aws_s3_bucket.s3_bucket_resource.id
      versioning_configuration {
            status                  = var.versioning_enabled
      }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_sse_resource" {
      bucket                        = aws_s3_bucket.s3_bucket_resource.id
      rule {
            apply_server_side_encryption_by_default {
                  sse_algorithm     = var.sse_algorithm
                  kms_master_key_id = var.kms_master_key_id
            }
      }
}
resource "aws_s3_bucket_accelerate_configuration" "s3_accelerate_configuration_resource" {
      bucket                        = aws_s3_bucket.s3_bucket_resource.id
      status                        = var.acceleration_enabled
}

resource "aws_s3_bucket_public_access_block" "s3_block_public_access_resource" {
      bucket                        = aws_s3_bucket.s3_bucket_resource.id
      block_public_acls             = var.block_public_acls
      block_public_policy           = var.block_public_policy
      ignore_public_acls            = var.ignore_public_acls
      restrict_public_buckets       = var.restrict_public_buckets
}


resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket_resource.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = flatten([
      {
        Sid       = "AllowSSLRequestsOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket_resource.id}",
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket_resource.id}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      var.additional_statements
    ])
  })
}


# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket = aws_s3_bucket.s3_bucket_resource.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = "*"
#         Action = "s3:GetObject"
#         Resource = "${aws_s3_bucket.s3_bucket_resource.arn}/*"
#       }
#     ]
#   })
# }

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_configuration_resource" {
  bucket = aws_s3_bucket.s3_bucket_resource.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id      = rule.value.id
      status  = rule.value.enabled ? "Enabled" : "Disabled"

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transitions
        content {
          noncurrent_days     = noncurrent_version_transition.value.days
          storage_class       = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = [rule.value.noncurrent_version_expiration]
        content {
          noncurrent_days     = noncurrent_version_expiration.value.days
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = [rule.value.abort_incomplete_multipart_upload]
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value.days_after_initiation
        }
      }
    }
  }
}