resource "aws_guardduty_detector" "master" {
  count    = var.guardduty ? 1 : 0
  provider = aws.master
  enable   = true
}

resource "aws_ssm_parameter" "guardduty_id" {
  count    = var.guardduty ? 1 : 0
  provider = aws.master
  name     = "/account/master/guardduty_id"
  type     = "String"
  value    = aws_guardduty_detector.master[0].id
}

resource "aws_guardduty_publishing_destination" "guardduty" {
  count           = var.guardduty ? 1 : 0
  provider        = aws.master
  detector_id     = aws_guardduty_detector.master[0].id
  destination_arn = aws_s3_bucket.guardduty.arn
  kms_key_arn     = aws_kms_key.s3_guardduty.arn
}
