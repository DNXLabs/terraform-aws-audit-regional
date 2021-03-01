resource "aws_lambda_function" "guardduty_notification" {
  count         = var.enable_guardduty_notification ? 1 : 0
  filename      = "${path.module}/lambda.zip"
  function_name = "guardduty_notification_lambda"
  role          = aws_iam_role.guardduty_iam_role[0].arn
  handler       = "main.lambda_handler"

  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  runtime = "python3.8"

  environment {
    variables = {
      slack_webhook   = var.slack_webhook,
      event_threshold = var.event_threshold
    }
  }
}

resource "aws_lambda_permission" "guardduty_notification" {
  count         = var.enable_guardduty_notification ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.guardduty_notification[0].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.guardduty_notification[0].arn
}