variable "nome" {
  type = string
}

variable "region" {
  type = string
}

variable "map_tags" {
  type = map(string)
}

variable "sgrule_cidr_blocks" {
  type = list(string)
}