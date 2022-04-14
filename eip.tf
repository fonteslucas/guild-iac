resource "aws_eip" "web-eip" {
  count = var.environment == "prod" ? 1 : 0
  tags  = var.eip_tag
}

