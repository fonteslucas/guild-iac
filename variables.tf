variable "region" {
  description = "AWS Region"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "s3_bucket_tags" {
  description = "Tags applied to the S3 bucket"
  type        = map(any)
}

variable "iam_role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "iam_role_tags" {
  description = "IAM role tags"
  type        = map(any)
}

variable "environment" {
  description = "Changes the resource's default parameters"
  type        = string
}
