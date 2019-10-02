---
title: App Files
categories: extras
nav_order: 54
---

As part of `lono cfn deploy`, the in the `app/files` folder can get zipped and uploaded to the lono managed s3 bucket. The files only get uploaded if they are referenced in your template with the `file_s3_url`.

## Lambda Function Example

The `app/files` are particularly useful for Lambda function resources.   Example:

```ruby
resource("function", "AWS::Lambda::Function",
  code: {
    s3_bucket: s3_bucket,
    s3_key: file_s3_key("index.rb"),
  },
  handler: "index.lambda_handler",
  role: get_att("lambda_execution_role.arn"),
  runtime: "ruby2.5",
  timeout: "300"
)
```

You can then define the source code for the lambda function in `app/files`.  Example:

app/files/index.rb:

```ruby
def lambda_handler(event:, context:)
  puts "hello"
end
```

Lono will zip up the file in a package that works with Lambda.

## Zipping Folders

If pass `file_s3_key` a folder instead of a file, lono will zip up the entire contents within the folder.

{% include prev_next.md %}
