variable "name-vpc" {
  type = string
}

variable "cidr-vpc" {
  type = string
}

variable "availability-zones" {
  type = list(any)
}

variable "cidr_private" {
  type = list(any)
}

variable "cidr_public" {
  type = list(any)
}

variable "region" {
  type = string
}

# variable "cidrsubnets" {
#   type = string
# }


