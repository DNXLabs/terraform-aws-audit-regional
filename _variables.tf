variable "org_name" {
  description = "Name for this organization (not actually used in API call)"
}

variable "account_ids" {
  default     = []
  description = "AWS Account IDs under Auditing for the organization"
}

variable "s3_days_until_glacier" {
  default     = 90
  description = "How many days before transitioning files to Glacier"
}

variable "guardduty" {
  default     = true
  description = "Enable/Disables guardduty"
}

variable "enable_guardduty_notification" {
  default     = false
  description = "Enable/Disables guardduty findings slack notification"
}

variable slack_webhook {
  default     = ""
  description = "Slack webhook which will receive guardduty notification"
}

variable event_threshold {
  default     = "0"
  description = "Filtering out events by severity or noisy alerts"
}

