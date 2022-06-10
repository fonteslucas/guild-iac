resource "aws_s3_bucket" "website_bucket" {

  bucket = var.domain_name
  tags = {
    "Departamento" = var.tags_validation
  }
}

resource "aws_s3_bucket_acl" "website_bucket_acl" {
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.website_policy.json
}

resource "aws_s3_bucket_website_configuration" "configuration_s3" {
  bucket = aws_s3_bucket.website_bucket.bucket
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "bucket_index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "./site/index.html"
  content_type = "text/html"
  acl          = "public-read"
}