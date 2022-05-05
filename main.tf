resource "random_string" "random" {
  for_each         = var.bucket_names
  length           = 10
  special          = false
  upper            = false
  override_special = "!@#$%"
}

resource "aws_s3_bucket" "buckets" {

  for_each = var.bucket_names

  bucket = "${each.key}-guild-iac-${random_string.random[each.key].result}"

}

resource "aws_s3_bucket_versioning" "versioning_example" {
  for_each = var.bucket_names

  bucket = aws_s3_bucket.buckets[each.key].id

  versioning_configuration {
    status = each.value.versioning
  }
}

