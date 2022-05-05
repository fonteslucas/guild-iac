resource "random_string" "random" {
  count = length(var.bucket_names)
  length           = 10  
  special          = false
  upper            = false
  override_special = "!@#$%"
}

resource "aws_s3_bucket" "buckets" {
  bucket = "${var.bucket_names[count.index]}-guild-iac-${random_string.random[count.index].result}"
  count  = length(var.bucket_names)
}
