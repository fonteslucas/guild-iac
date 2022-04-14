resource "random_string" "random" {
  length           = 5
  special          = false
  upper            = false
  override_special = "/@£$"
}

resource "aws_s3_bucket" "bucketS3" {
  bucket = can(var.environment) ? "${var.s3_bucket_name}-${random_string.random.result}-${var.environment}" : "${var.s3_bucket_name}-${random_string.random.result}"

  tags = can(var.environment) ? merge(var.s3_bucket_tags, {Environment = "${var.environment}"}) : var.s3_bucket_tags
}

resource "aws_security_group" "securityGroup" {
  name = can(var.environment) ? "${var.sg_name}-${var.environment}" : var.sg_name
}

resource "aws_security_group_rule" "sgRule" {
  security_group_id = aws_security_group.securityGroup.id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8090
  protocol          = "tcp"
  description       = "Service Ports"
  cidr_blocks       = var.environment != "PRD" ? [ "0.0.0.0/0", "::/0" ] : var.sg_rule_cidr
}
