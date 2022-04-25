resource "aws_s3_bucket" "object_s3" {
  bucket = "deivid-object-img"
  acl    = "public-read"
}

# Upload of file
resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.object_s3.bucket
  key          = "certificacao.png"
  acl          = "public-read"
}