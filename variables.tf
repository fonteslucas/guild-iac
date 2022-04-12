variable "region" {
  description = "AWS Region where resources will be deployed"
  type = string
  default = "us-east-2"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type = string
}

variable "s3_bucket_tags" {
  description = "Tags applied to the S3 bucket"
  type = map(object({
    Name = string
    Owner = string
  }))
}

variable "sg_name" {
  description = "Security Group Name"
  type = string
}

variable "sg_rule_cidr" {
  description = "SG Rules CIDR Blocks"
  type = list(string)
}