resource "aws_s3_bucket" "this" {
  for_each = var.create_s3_bucket ? var.s3_bucket_details : {}
  bucket   = each.value["bucket_name"]
}

# S3 for Artifact Store
resource "aws_s3_bucket_policy" "this" {
  for_each = var.s3_bucket_details
  bucket   = aws_s3_bucket.this[each.key].id
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Id": "SSEAndSSLPolicy",
  "Statement": [
    {
      "Sid": "DenyUnEncryptedObjectUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${each.value["bucket_name"]}/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "aws:kms"
        }
      }
    },
    {
      "Sid": "DenyInsecureConnections",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${each.value["bucket_name"]}/*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
EOF
}


# # S3 Static Website
# resource "aws_s3_bucket_public_access_block" "this" {
#   for_each = var.s3_bucket_details
#   bucket   = aws_s3_bucket.this[each.key].id

#   block_public_acls       = false
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# # S3 Static Website
# resource "aws_s3_bucket_policy" "this" {
#   for_each = var.s3_bucket_details
#   bucket   = aws_s3_bucket.this[each.key].id
#   policy   = <<EOF
# {
#   "Version": "2008-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "s3:GetObject",
#       "Resource": [
#         "${aws_s3_bucket.this[each.key].arn}/*",
#         "${aws_s3_bucket.this[each.key].arn}"
#       ],
#       "Condition": {
#         "IpAddress": {
#           "aws:SourceIp": [
#             "${each.value["source_ip"]}/32"
#           ]
#         }
#       }
#     }
#   ]
# }
# EOF
# }
