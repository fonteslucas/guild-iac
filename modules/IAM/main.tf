resource "aws_iam_role" "roles3" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
  managed_policy_arns = [aws_iam_policy.s3-read.arn]
}

resource "aws_iam_policy" "s3-read" {
  policy = data.aws_iam_policy_document.s3-read.json
}