skip = true

locals {
    env_config = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
      # Extract the variables we need for easy access
    account_name = local.env_config.account_name
    aws_region   = local.env_config.aws_region
}

inputs = {
    project_name = "${basename(get_terragrunt_dir())}"
    aws_region      = local.aws_region
    s3_bucket_name  = "laksh123"
    environment     = local.env_config.environment_name

}

terraform {
    source = "${get_parent_terragrunt_dir()}/../../../../..//configuration/s3bucket"
}

remote_state {
    backend = "s3"
    config = {
    encrypt        = true
    bucket         = "stg${local.env_config.project_code}${local.env_config.environment_name}-${local.env_config.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
    }
    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }    
}
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
}
EOF
}