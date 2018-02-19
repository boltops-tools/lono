Generates a CloudFormation preview.  This is similar to a `terraform plan` or puppet's dry-run mode.

Example output:

CloudFormation preview for 'example' stack update. Changes:

Remove AWS::Route53::RecordSet: DnsRecord testsubdomain.sub.tongueroo.com

Examples:

  lono cfn preview my-stack
