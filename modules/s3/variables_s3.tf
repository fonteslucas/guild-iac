variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type = string
}

variable "s3_bucket_tags" {
  description = "Tags applied to the S3 bucket"
  type = map
}

variable "environment" {
  description = "Changes the resource's default parameters"
  type = string
}