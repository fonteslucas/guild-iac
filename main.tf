resource "random_string" "random" {
  length           = 5
  special          = false
  upper            = false
  override_special = "/@£$"
}

resource "aws_s3_bucket" "hugo-bucket-s3" {
  bucket = "example"
}

resource "aws_s3_bucket" "bucketS3" {
  bucket = "${var.s3_bucket_name}-${random_string.random.result}"
}