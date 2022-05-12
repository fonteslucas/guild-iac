data "aws_iam_policy_document" "assume-role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "s3-read" {
  statement {
    effect    = "Allow"
    actions   = ["S3:ListBucket"]
    resources = var.output_s3
  }
}