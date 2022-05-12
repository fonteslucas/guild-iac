output "arn" {
    value = [for i in aws_s3_bucket.bucketS3ForEach : i.arn]
}

/*
output "arn_policy" {
    value = [for i in aws_s3_bucket.bucketS3ForEach : "${i.arn}/*"]
}
*/