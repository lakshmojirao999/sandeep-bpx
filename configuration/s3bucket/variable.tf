# Global Variables ---------------------------------------
variable "aws_region" {}
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

# Tags ------------------------------------------------
variable "tags" {
  
  default     = {
     Environment = "Test"
     Owner       = "TFProviders"
     Project     = "Test"
 
    }
  type = map(any)
}

variable "author" {
  description = "Enter the email ID of the person who is creating/editing this infrastructure."
    default     = "lakshmoji+sre"
}

variable "created_by" {
  description = "Enter the name of the tool used to create it. e.g: Terraform or Terragrunt."
    default   = "Terragrunt"
}