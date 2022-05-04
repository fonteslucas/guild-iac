resource "aws_s3_bucket" "bucketS3Count" {
  count = 4

  bucket = can(var.environment) ? "count-${var.s3_bucket_name[count.index]}-${var.environment}" : "count-${var.s3_bucket_name[count.index]}}"

  tags = can(var.environment) ? merge(var.s3_bucket_tags, { Environment = "${var.environment}" }) : var.s3_bucket_tags

}

resource "aws_s3_bucket" "bucketS3ForEach" {
  for_each = toset( ["a","b","c","d"] )

  bucket = can(var.environment) ? "for-${var.s3_bucket_name}-${each.key}-${var.environment}-" : "for-${var.s3_bucket_name}-${each.key}"

  tags = can(var.environment) ? merge(var.s3_bucket_tags, { Environment = "${var.environment}" }) : var.s3_bucket_tags

}