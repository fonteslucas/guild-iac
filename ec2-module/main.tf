resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instancetype

  tags = {
    Name = var.environment == "teste" ? var.environment : "Valor era diferente de teste ai mudei"
  }
}