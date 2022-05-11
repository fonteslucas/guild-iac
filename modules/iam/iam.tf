resource "aws_iam_role" "role_s3_read" {
  name = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  managed_policy_arns = [aws_iam_policy.read_s3_bucket.arn]
  tags = var.iam_role_tags
}

resource "aws_iam_policy" "read_s3_bucket" {
  policy = data.aws_iam_policy_document.s3_read.json
}