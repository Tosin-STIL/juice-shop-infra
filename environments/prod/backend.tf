terraform {
  backend "s3" {
    bucket         = "juice-shop-terraform-state-10-50-29"
    key            = "prod/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "juice-shop-terraform-locks"
    encrypt        = true
  }
}
