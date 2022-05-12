data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_read" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    effect    = "Allow"
    #resources = var.s3_bucket_arns
    #resources = [for i in var.s3_bucket_arns : "${i}/*"]
    resources = formatlist("%s/*",var.s3_bucket_arns)
  }
}

/*
Mapa com vários mapas
{

"a": {
id : ""
arn : ""
}, 
"b": {
id : ""
arn : ""
}
}


["arn:bucket-1","arn:bucket-2"]

*/


