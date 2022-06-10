variable "domain_name" {
  type        = string
  description = "Armazena o nome do dominio"
}

variable "tags_validation" {
  type        = string
  description = "Faz a validacao de tags"
  validation {
    condition = contains([
      "Marketing",
      "RH",
      "Financeiro",
      "TI"
    ], var.tags_validation)
    error_message = "Valores de tags nao correspondem ao esperado."
  }
}