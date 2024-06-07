module "s3-website" {
  source            = "../../modules/s3-bucket"
  create_s3_bucket  = true
  s3_bucket_details = var.s3_bucket_details
}
