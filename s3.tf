resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-tf-test-bucket-deivid-duarte"

  tags = {
    Name  = "My bucket"
    Owner = "Deivid Duarte"
  }
}


# Time, os dois desafios pro fds~quarta



# Desafio 1 - Usando Variavel Map
# No mesmo recurso do S3, adicionar tags utilizando variáveis do tipo map.

# Name = value
# Owner = value
# Desafio 2 - Usando Variavel List
# Criar SG e um SG rule. Na SG rule personalizar os cidr_blocks 
#usando uma variavel do tipo lista.