locals {
  elb_principal = {
    "us-east-1" : "127311923021"
    "us-east-2" : "033677994240"
    "us-west-1" : "027434742980"
    "us-west-2" : "797873946194"
    "af-south-1" : "098369216593"
    "ca-central-1" : "985666609251"
    "eu-central-1" : "054676820928"
    "eu-west-1" : "156460612806"
    "eu-west-2" : "652711504416"
    "eu-south-1" : "635631232127"
    "eu-west-3" : "009996457667"
    "eu-north-1" : "897822967062"
    "ap-east-1" : "754344448648"
    "ap-northeast-1" : "582318560864"
    "ap-northeast-2" : "600734575887"
    "ap-northeast-3" : "383597477331"
    "ap-southeast-1" : "114774131450"
    "ap-southeast-2" : "783225319266"
    "ap-south-1" : "718504428378"
    "me-south-1" : "076674570225"
    "sa-east-1" : "507241528517"
    "us-gov-west-1" : "048591011584"
    "us-gov-east-1" : "190560391635"
    "cn-north-1" : "638102146993"
    "cn-northwest-1" : "037604701340"
  }
}

data "aws_iam_policy_document" "s3_access_logs_policy" {
  statement {
    sid    = "s3AccessLogsPolicySid1"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [format("arn:aws:s3:::%s-audit-alb-access-logs-%s", var.org_name, data.aws_region.current.name)]
  }

  statement {
    sid    = "s3AccessLogsPolicySid2"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [local.elb_principal[data.aws_region.current.name]]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = formatlist("arn:aws:s3:::%s-audit-alb-access-logs-%s/AWSLogs/%s/*",
      var.org_name,
      data.aws_region.current.name,
    var.account_ids)
  }

  statement {
    sid    = "s3AccessLogsPolicySid3"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = formatlist("arn:aws:s3:::%s-audit-alb-access-logs-%s/AWSLogs/%s/*",
      var.org_name,
      data.aws_region.current.name,
    var.account_ids)

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket" "alb_access_logs" {
  bucket = "${var.org_name}-audit-alb-access-logs-${data.aws_region.current.name}"
  acl    = "private"
  policy = data.aws_iam_policy_document.s3_access_logs_policy.json

  lifecycle {
    ignore_changes = [
      versioning,
      grant
    ]
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "ARCHIVING"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = var.s3_days_until_glacier
      storage_class = "GLACIER"
    }
  }
}

