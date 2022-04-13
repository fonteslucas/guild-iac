resource "random_string" "random" {
  length           = 5
  special          = false
  upper            = false
  override_special = "/@£$"
}

resource "aws_s3_bucket" "bucketS3" {
  bucket = "${var.s3_bucket_name}-${random_string.random.result}"
  
  /*
    tags = {
      name = "${var.tags["name"]}"
      # name = var.tags["name"]
      owner = "${var.tags["owner"]}"
    }
*/
    tags = var.tags
  

}


resource "aws_security_group" "allow-hugo" {
  name = "allow-hugo"
  description = "Allow Minhas Regras"
  #count = var.vpc_cidr_blocks["count"]

  ingress {
    description = "TLS from VPC"
    from_port = 443 
    to_port = 443
    protocol = "tcp"
    #cidr_blocks = "${var.vpc_cidr_blocks}"
    #cidr_blocks = var.vpc_cidr_blocks
    #cidr_blocks = var.vpc_cidr_blocks[count.index]
    cidr_blocks = [var.vpc_cidr_blocks[0]]
    #cidr_blocks = tolist(var.vpc_cidr_blocks)[count.index % length(var.vpc_cidr_blocks)]
  }

  
}
/*
resource "aws_security_group_rule" "teste" {
count = length(var.vpc_cidr_blocks)

 description = "TLS from VPC"
    from_port = 443 
    to_port = 443
    protocol = "tcp"
    #cidr_blocks = "${var.vpc_cidr_blocks}"
    #cidr_blocks = var.vpc_cidr_blocks
    #cidr_blocks = var.vpc_cidr_blocks[count.index]
    #cidr_blocks = [var.vpc_cidr_blocks[0]]
    #cidr_blocks = tolist(var.vpc_cidr_blocks)[count.index % length(var.vpc_cidr_blocks)]
    cidr_blocks = [var.vpc_cidr_blocks[count.index]]

}
*/
#fazer um exemploe de import