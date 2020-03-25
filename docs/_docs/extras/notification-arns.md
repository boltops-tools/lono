---
title: Notification ARNs
categories: extras
nav_order: 99
---

You can specific notification arns for CloudFormation stack related events with a CLI option or in [configs/settings.yml]({% link _docs/configuration/settings.md %}).

## Example: CLI option

    lono cfn deploy demo --notification-arns arn:aws:sns:us-west-2:112233445566:my-sns-topic1 arn:aws:sns:us-west-2:112233445566:my-sns-topic2

Future deploys will maintain the `--notification-arns` value.  If you want to remove the notification-arn then you can provide an empty string.

    lono cfn deploy demo --notification-arns ''

## Example: settings.yml

configs/settings.yml

```yaml
base:
  notification_arns:
  - arn:aws:sns:us-west-2:112233445566:my-sns-topic1
```

This will globally provide the `notification_arns` option to all `lono cfn deploys`. This will also override the the CLI option.

{% include prev_next.md %}
