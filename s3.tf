resource "random_string" "random" {
  length = 6
  special = false
  upper = false
  override_special = "!@#$%"
}

resource "aws_s3_bucket" "b" {
  bucket = "${random_string.random.result}-dallisonlimateste-${var.nome}"
  tags = var.map_tags
}

