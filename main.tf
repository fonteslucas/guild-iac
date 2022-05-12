module "s3" {
  source         = "./modules/s3"
  s3_bucket_name = var.s3_bucket_name
  s3_bucket_tags = var.s3_bucket_tags
  environment    = var.environment
}

module "iam" {
  source        = "./modules/iam"
  iam_role_name = var.iam_role_name
  iam_role_tags = var.iam_role_tags
  #s3_bucket_arns = module.s3.arn_policy
  s3_bucket_arns = module.s3.arn
}
