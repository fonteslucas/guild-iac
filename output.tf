/*para que uma alteração no código seja reconhecida, devemos utilizar  o comando terraform apply novamete*/


output "buket" {
  value = aws_s3_bucket.bucketS3.*.id
  #value = aws_s3_bucket.bucketS3.0.id
}
