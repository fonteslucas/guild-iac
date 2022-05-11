resource "aws_iam_policy" "policy" {
  name = var.iam_policy_name
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
        ]
        Effect = "Allow"
        Resource = [
          "aws_s3_bucket.bucketS3Count[0].arn",
          "aws_s3_bucket.bucketS3Count[1].arn",
          "aws_s3_bucket.bucketS3Count[2].arn",
          "aws_s3_bucket.bucketS3Count[3].arn"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "role_s3_read" {
  name = var.iam_role_name

  assume_role_policy = aws_iam_policy.policy

  tags = var.iam_role_tags
}
