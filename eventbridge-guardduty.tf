resource "aws_cloudwatch_event_rule" "guardduty_notification" {
  count         = var.enable_guardduty_notification ? 1 : 0
  provider      = aws.master
  name          = "${var.org_name}-notification-guardduty-${data.aws_region.current.name}"
  event_pattern = file("${path.module}/eventbridge.json")
}

resource "aws_cloudwatch_event_target" "guardduty_notification" {
  count     = var.enable_guardduty_notification ? 1 : 0
  provider  = aws.master
  rule      = aws_cloudwatch_event_rule.guardduty_notification[0].name
  target_id = "lambda"
  arn       = aws_lambda_function.guardduty_notification[0].arn
}