resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-tf-test-bucket-deivid-duarte"

  tags = {
    Name  = "My bucket"
    Owner = "Deivid Duarte"
  }
}

