variable "environment" {
  description = "Will create eip if defined prod in field default else will not create"
  type        = string
  default     = "dev"
}

variable "eip_tag" {
  type = map
  default = {
    "Name" = "eip_terraform"
  }
}