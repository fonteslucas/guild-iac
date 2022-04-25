output "website_endpoint" {
  description = "The public url of this website."
  value = aws_s3_bucket.object_s3.bucket_domain_name
}