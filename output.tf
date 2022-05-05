output "arn" {
  value = [for k in aws_s3_bucket.buckets : k.arn]
}

# output "bucket_just-one" {
#   value = aws_s3_bucket.buckets.1.id
# }