variable "source_repo_name" {
  description = "Source repo name"
  type        = string
}

variable "source_repo_branch" {
  description = "Source repo branch"
  type        = string
}

variable "image_repo_name" {
  description = "Image repo name"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  sensitive   = true
}

# variable "role_arn" {
#   description = "AWS IAM Role"
#   type        = string
#   sensitive   = true
# }

variable "map_tags_auto" {
  type = map(string)
}