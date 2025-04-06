# terraform/backend.tf 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92.0"
    }
  }

  backend "s3" {
    bucket  = ""
    key     = ""
    region  = ""
    encrypt = ""
    // can use dynamodb_table but use_lockfile is new approach 
    // no managing of db all done in s3 itself so new is better
    use_lockfile = ""
  }
}