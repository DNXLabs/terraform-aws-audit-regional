output "config_s3_bucket_name" {
  value = aws_s3_bucket.config.bucket
}

output "logs_s3_bucket_name" {
  value = aws_s3_bucket.logs.bucket
}

output "guardduty_s3_bucket_name" {
  value = aws_s3_bucket.guardduty.bucket
}

output "guardduty_id" {
  value = var.guardduty ? aws_guardduty_detector.master[0].id : ""
}
