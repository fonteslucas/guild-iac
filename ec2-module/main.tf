resource "aws_instance" "web" {
  ami           = "ami-03ededff12e34e59e"
  instance_type = "t2.micro"

  tags = {
    Name = var.environment == "teste" ? var.environment : "Valor era diferente de teste ai mudei"
  }
}