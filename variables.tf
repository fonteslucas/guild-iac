variable "region" {
  type = string
  default = "us-east-2"
}

variable "s3_bucket_name" {
  type = string
}

variable "tags" {
  type = map
  default = {
    name = "My-Bucket"
    owner = "Hugo-Barros"
    iac = "true"
    CostCenter = "1234"
  }
}

variable "vpc_cidr_blocks" {
  type = list
  default = ["172.31.0.0/16", "172.32.0.0/16", "10.0.0.0/16", "10.60.0.0/16"]
}

/*
variable "vpc_cidr_blocks" {
  type = list(object({
    cidr_blocks = string
  }))
  default = [
    {
      cidr_blocks = "172.31.0.0/16"
    }
  ]
}
*/