variable "region" {
  description = "AWS Region to deploy resources"
  type = string
}

variable "vpc_name" {
  description = "Name of the Virtual Private Network"
  type = string
}

variable "cidr_range" {
  description = "CIDR Range of the Virtual Private Network"
  type = string
}

variable "cidr_notation" {
  description = "CIDR notation to help determine subnets"
  type = list(string)
}

