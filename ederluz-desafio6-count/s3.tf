variable "s3_bucket_name" {
  type = list
  default = ["bucket-do-eder-a", "bucket-do-eder-b", "bucket-do-eder-c"]
}

resource "aws_s3_bucket" "meus_buckets" {
   count = length(var.s3_bucket_name)
   bucket = var.s3_bucket_name[count.index]
   acl = "private"
   versioning {
      enabled = true
   }
   force_destroy = "true"
}

output "s3_bucket_id" {
  value       = aws_s3_bucket.meus_buckets.0.id
}