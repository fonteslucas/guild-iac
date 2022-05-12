module "S3" {
  source = "./modules/S3"

  bucket_names = var.bucket_names
}

module "IAM" {
  source    = "./modules/IAM"
  path      = "/"
  name      = var.name_policy
  output_s3 = module.S3.arn_teste
}

