# Global Variables ---------------------------------------

variable "environment" {
  description = "Enter the name of the environment."
}

# S3 Variables ------------------------------------------
variable "s3_bucket_name" {
  description = "Enter a unique name for the S3 bucket."
}

variable "s3_encrypt" {
  description = "Enter true/false to enable/disable encryption. Default value is 'false'"
  default     = false
}

variable "s3_acl" {
  description = "Enter an S3 ACL (e.g. private/public)."
  default     = "private"
}

variable "tags" {
  type = map(any)
}
variable "author" {
  description = "Enter the email ID of the person who is creating/editing this infrastructure."
}

variable "created_by" {
  description = "Enter the name of the tool used to create it. e.g: Terraform or Terragrunt."
    default   = "Terragrunt"
}



resource "aws_s3_bucket" "s3_bucket" {
  count = var.s3_encrypt == false ? 1 : 0

  bucket = format("%s-%s", var.s3_bucket_name, var.environment)
  acl    = var.s3_acl

  tags = merge(
    {
      "Name" = format("%s-%s", var.s3_bucket_name, var.environment)
    },
    var.tags,
  )
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access" {
  count = var.s3_encrypt == false ? 1 : 0

  bucket = join(", ", aws_s3_bucket.s3_bucket[*].id)
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



resource "aws_s3_bucket" "s3_bucket_encrypt" {
  count = var.s3_encrypt == true ? 1 : 0

  bucket = format("%s-%s", var.s3_bucket_name, var.environment)
  acl    = var.s3_acl

#  policy = var.bucket_policy

#  versioning {
#    enabled = var.version_enabled
#  }

  // server_side_encryption_configuration {
  //   rule {
  //     apply_server_side_encryption_by_default {
  //       kms_master_key_id = join(", ", module.kms_key_s3[*].kms_key_arn)
  //       sse_algorithm     = "aws:kms"
  //     }
  //   }
  // }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }  

  tags = merge(
    {
      "Name" = format("%s-%s", var.s3_bucket_name, var.environment)
    },
    var.tags,
  )
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_encrypt" {
  count = var.s3_encrypt == true ? 1 : 0
  
  bucket = join(", ", aws_s3_bucket.s3_bucket_encrypt[*].id)
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "s3_bucket_id" {
  description   = "Prints S3 Bucket ID."
  value         = aws_s3_bucket.s3_bucket[*].id
}

output "s3_bucket_arn" {
  description   = "Prints S3 ARN ID."
  value         = aws_s3_bucket.s3_bucket[*].arn
}

output "s3_bucket_encrypt_id" {
  description   = "Prints S3 Bucket ID."
  value         = aws_s3_bucket.s3_bucket_encrypt[*].id
}

output "s3_bucket_encrypt_arn" {
  description   = "Prints S3 ARN ID."
  value         = aws_s3_bucket.s3_bucket_encrypt[*].arn
}