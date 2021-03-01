resource "aws_iam_role" "guardduty_iam_role" {
  count              = var.enable_guardduty_notification ? 1 : 0
  name               = "${var.org_name}-notification-guardduty-${data.aws_region.current.name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "guardduty_lambda_logging" {
  count  = var.enable_guardduty_notification ? 1 : 0
  name   = "${var.org_name}-notification-guardduty-${data.aws_region.current.name}"
  path   = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:PutLogEvents"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "guardduty_lambda_logs" {
  count      = var.enable_guardduty_notification ? 1 : 0
  role       = aws_iam_role.guardduty_iam_role[0].name
  policy_arn = aws_iam_policy.guardduty_lambda_logging[0].arn
}