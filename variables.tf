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
  }
}

/*variable "s3_count" {
  default     = 3
  type        = string
}*/

