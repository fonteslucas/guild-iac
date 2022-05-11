variable "iam_policy_name" {
  description = "Name of the IAM policy"
  type = string
}

variable "iam_role_name" {
  description = "Name of the IAM role"
  type = string
}

variable "iam_role_tags" {
  description = "IAM role tags"
  type = map
}