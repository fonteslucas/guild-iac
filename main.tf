resource "random_string" "random" {
  length           = 5
  special          = false
  upper            = false
  override_special = "/@£$"
}

resource "aws_s3_bucket" "bucketS3" {
  bucket = "${var.s3_bucket_name}-${random_string.random.result}"

  tags = var.s3_bucket_tags
}

resource "aws_security_group" "securityGroup" {
  name = var.sg_name
}

resource "aws_security_group_rule" "sgRule" {
  security_group_id = aws_security_group.securityGroup.id
  type = "ingress"
  from_port = 8080
  to_port = 8090
  protocol = "tcp"
  description = "Service Ports"
  cidr_blocks = var.sg_rule_cidr
  self = true
}