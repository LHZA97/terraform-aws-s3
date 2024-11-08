###############################################################
#                     S3 Bucket General                       #
###############################################################


variable "bucket_name" {
    type = string
    description = "Name of the S3 bucket"
}

variable "force_destroy" {  
    type = bool
    description = "Force destroy the S3 bucket"
    default = true
    validation {
        condition = contains([true, false], var.force_destroy)
        error_message = "Invalid input, options: \"true\", \"false\"."
    }    
}

variable "object_lock_enabled" {
    type = bool
    description = "Enable object lock for the S3 bucket"
    default = false
    validation {
        condition = contains([true, false], var.object_lock_enabled)
        error_message = "Invalid input, options: \"true\", \"false\"."
    }
}

variable "encryption_enabled" {
    type = bool
    description = "Enable encryption for the S3 bucket"
    default = true
    validation {
      condition = contains([true, false], var.encryption_enabled)
      error_message = "Invalid input, options: \"true\", \"false\"."
    }
}


variable "server_access_logging_enabled" {
    type = bool
    description = "Enable server access logging for the S3 bucket"
    default = true
    validation {
        condition = contains([true, false], var.server_access_logging_enabled)
        error_message = "Invalid input, options: \"true\", \"false\"."
    }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

###############################################################
#                     S3 Bucket Logging                       #
###############################################################

variable "target_bucket" {
  type = string
  description = "Name of the target S3 bucket for access logging"
  default = "s3://s3-accesslogs-ap-southeast-1-420792623485"
}

variable "target_prefix" {
    type = string
    description = "Prefix for the target S3 bucket for access logging"
    default = ""

}

###############################################################
#                     S3 Bucket SSE                           #
###############################################################


variable "sse_algorithm" {
    type = string
    description = "Server-side encryption algorithm to use"
    default = "aws:kms"
    validation {
        condition = contains(["AES256", "aws:kms", "aws:kms:dsse"], var.sse_algorithm)
        error_message = "Invalid input, options: \"AES256\", \"aws:kms\" , \"aws:kms:dsse\"."
    }   
}

variable "kms_master_key_id" {
    type = string
    description = "KMS master key ID to use for SSE-KMS encryption"
    default = null
}


###############################################################
#                  S3 Bucket Versioning                       #
###############################################################


variable "versioning_enabled" {
    type = string
    description = "Enable versioning for the S3 bucket"
    default = "Enabled"
    validation {
        condition = contains(["Enabled", "Suspended", "Disabled"], var.versioning_enabled)
        error_message = "Invalid input, options: \"true\", \"false\"."
    }
}

###############################################################
#                  S3 Bucket Acceleration                     #
###############################################################


variable "acceleration_enabled" {
    type = string
    description = "Enable S3 bucket acceleration"
    default = "Suspended"
    validation {
        condition = contains(["Enabled", "Suspended"], var.acceleration_enabled)
        error_message = "Invalid input, options: \"true\", \"false\"."
        }
}


###############################################################
#              S3 Bucket Block Public Access                  #
###############################################################

variable "block_public_acls" {
    type = bool
    description = "Whether Amazon S3 should block public ACLs for this bucket"
    default = true
    validation {
        condition = contains([true, false], var.block_public_acls)
        error_message = "Invalid input, options: \"true\", \"false\"."
        }
}

variable "block_public_policy" {
    type = bool
    description = "Whether Amazon S3 should block public bucket policies for this bucket"
    default = true
    validation {
        condition = contains([true, false], var.block_public_policy)
        error_message = "Invalid input, options: \"true\", \"false\"."
        }
}

variable "ignore_public_acls" {
    type = bool
    description = "Whether Amazon S3 should ignore public ACLs for this bucket"
    default = true
    validation {
        condition = contains([true, false], var.ignore_public_acls)
        error_message = "Invalid input, options: \"true\", \"false\"."
        }
}

variable "restrict_public_buckets" {
    type = bool
    description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
    default = true
    validation {
        condition = contains([true, false], var.restrict_public_buckets)
        error_message = "Invalid input, options: \"true\", \"false\"."
        }
}


###############################################################
#                S3 Bucket LifecyclePolicy                    #
###############################################################

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the S3 bucket"
  type = list(object({
    id                                = string
    enabled                           = bool
    filter  = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
    expiration = object({days  = number})
    noncurrent_version_transitions    = list(object({
      days          = number
      storage_class = string
    }))
    noncurrent_version_expiration      = object({
      days = number
    })
    abort_incomplete_multipart_upload  = optional(object({
      days_after_initiation = number
    }))
  }))
}