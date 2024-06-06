resource "aws_s3_bucket" "this" {
  for_each = var.create_s3_bucket ? var.s3_bucket_details : {}
  bucket   = each.value["bucket_name"]
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each = var.s3_bucket_details
  bucket   = aws_s3_bucket.this[each.key].id

  block_public_acls       = false
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

