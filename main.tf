/*Criar mais de um S3 utilizando o mesmo bloco de resource com count
Criar output do nome de todos os s3s
Criar output de um S3 especifico*/

resource "random_string" "random" {
  length           = 5
  special          = false
  upper            = false
  override_special = "/@£$"
}

resource "aws_s3_bucket" "bucketS3" {
  count = 3
  bucket = "${var.s3_bucket_name}-${random_string.random.result}-${count.index}"
  
  
    tags = {
      name = "${var.tags["name"]}"
      owner = "${var.tags["owner"]}"
    }
  
}

