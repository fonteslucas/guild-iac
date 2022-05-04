output "bucketNames-Count" {
  value = aws_s3_bucket.bucketS3Count[*].id
}

output "bucket-Count" {
  value = aws_s3_bucket.bucketS3Count[2].id
}

/*
output "bucketNames-ForEach" {
  value = aws_s3_bucket.bucketS3ForEach[*].id
}
*/

output "bucketNames-ForEach" {
  value = [ for i in aws_s3_bucket.bucketS3ForEach : i.id]
}

output "bucket-ForEach" {
  value = aws_s3_bucket.bucketS3ForEach["a"].id
}