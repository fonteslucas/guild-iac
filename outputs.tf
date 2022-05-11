output "bucketARNs" {
  #value = [for i in module.s3 : i.arn]
  value = module.s3.arn
}

output "iam" {
  value = module.iam.arn
}