provider "aws" {
  region = var.region
  profile = "poc-delivery"
    assume_role {
    role_arn = "arn:aws:iam::373011342827:role/terraform-bitbucket-pipelines"
  }
}