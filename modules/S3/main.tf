resource "random_string" "random" {
  for_each         = var.bucket_names
  length           = 10
  special          = false
  upper            = false
  override_special = "!@#$%"
}

resource "aws_s3_bucket" "buckets" {
  for_each = var.bucket_names
  bucket   = "${each.key}-guild-iac-${random_string.random[each.key].result}"
}