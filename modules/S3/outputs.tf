output "arn" {
  value = [for k in aws_s3_bucket.buckets : k.arn]
}

output "arn_teste" {
  value = [for k in aws_s3_bucket.buckets : "${k.arn}/*"]
}