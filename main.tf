resource "random_string" "random" {
  length = 5
  special = true
  override_special = "!@#$%"
}

resource "aws_s3_bucket" "b" {
  bucket = var.nome

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}