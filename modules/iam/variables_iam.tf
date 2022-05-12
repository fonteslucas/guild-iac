variable "iam_role_name" {
  description = "Name of the IAM role"
  type = string
}

variable "iam_role_tags" {
  description = "IAM role tags"
  type = map
}

variable "s3_bucket_arns" {
  description = "ARNs dos buckets S3"
  type = list(string)
}