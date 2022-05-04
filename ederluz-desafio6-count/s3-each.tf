variable "s3_bucket_names" {
  type    = set(string)
  default = ["ederluz-guild1","ederluz-guild2","ederluz-guild3"]
}

resource "aws_s3_bucket" "buckets-eder" {
  for_each = var.s3_bucket_names

  bucket = each.key
  
}

 output "s3_bucket_id_for_each" {
   value       = [for i in aws_s3_bucket.buckets-eder : i.id]
 }

