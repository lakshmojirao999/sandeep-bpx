
module "s3bucket" {
    source = "../../modules/aws/s3"
    s3_bucket_name = var.s3_bucket_name
    environment = var.environment
    author      = var.author
    tags = {
      environment = var.environment
      author      = var.author       
    }
}