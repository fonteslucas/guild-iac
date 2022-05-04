data "aws_iam_policy_document" "role" {
  statement {
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = [ "events.amazonaws.com" ]
    }
    effect = "Deny"
  }
}