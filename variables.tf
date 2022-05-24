variable "name-vpc" {
  type = string
}

variable "cidr-vpc" {
  type = string
}

variable "availability-zones" {
  type = list(any)
}

variable "region" {
  type = string
}

