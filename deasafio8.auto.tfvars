region          = "us-east-1"
s3_bucket_name  = "s3-william"
s3_bucket_tags  = { Name = "My S3 Bucket", Owner = "William" }
iam_policy_name = "read_s3"
iam_role_name   = "read_buckets_role"
iam_role_tags   = { S3 = "Read_Only" }
environment     = "dev"
