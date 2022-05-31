variable "vpc_name" {
  type = string
}

variable "cidr_range" {
  type    = string
  default = "10.0.0.0/20"
}