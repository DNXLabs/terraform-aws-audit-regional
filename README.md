# terraform-aws-audit-buckets

[![Lint Status](https://github.com/DNXLabs/terraform-aws-audit-buckets/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-audit-buckets/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-audit-buckets)](https://github.com/DNXLabs/terraform-aws-audit-buckets/blob/master/LICENSE)

This terraform module creates buckets to save audit logs from accounts in the organization

The following resources will be created:
 -  AWS Config centralized bucket for Audit accounts
 -  Encrypted Bucket to save audit  logs

In addition, you have the option to specify:
 - How many days before transitioning files to Infrequent-Access (IA)
 - How many days before transitioning files to Glacier
 - Enable or not guardduty
 - Enable or not guardduty notification in case of findings

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| aws.master | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_ids | AWS Account IDs under Auditing for the organization | `list` | `[]` | no |
| enable\_guardduty\_notification | Enable/Disables guardduty findings slack notification | `bool` | `false` | no |
| event\_threshold | Filtering out events by severity or noisy alerts | `number` | `0` | no |
| guardduty | Enable/Disables guardduty | `bool` | `true` | no |
| org\_name | Name for this organization (not actually used in API call) | `any` | n/a | yes |
| s3\_days\_until\_glacier | How many days before transitioning files to Glacier | `number` | `90` | no |
| slack\_webhook | Slack webhook which will receive guardduty notification | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_access\_logs\_s3\_bucket\_arn | n/a |
| alb\_access\_logs\_s3\_bucket\_name | n/a |
| config\_s3\_bucket\_name | n/a |
| guardduty\_id | n/a |
| guardduty\_s3\_bucket\_name | n/a |
| logs\_s3\_bucket\_name | n/a |

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-audit-buckets/blob/master/LICENSE) for full details.
