output "bucket_name" {
  value = { for k, bucket in aws_s3_bucket.this : k => bucket.id }
}

output "bucket_arn" {
  value = { for k, bucket in aws_s3_bucket.this : k => bucket.arn }
}
