output "bucketARNs" {
  value = [for i in module.s3 : i.arn]
}

output "iam" {
  value = [for i in module.iam : i]
}
