variable "region" {
  type        = string
  description = "Variavel que armazena a regiao default"
}

variable "domain_name" {
  type        = string
  description = "armazena o nome do dominio"
}

variable "tag_departamento" {
  type        = string
  description = "Departamento para o qual sera criado o site. Valores aceitos = Marketing, RH, Financeiro & TI."
}