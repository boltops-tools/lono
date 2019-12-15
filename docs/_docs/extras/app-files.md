---
title: App Files
categories: extras
nav_order: 75
---

As part of [lono cfn deploy](/reference/lono-cfn-deploy/), the in the `app/files` folder can get zipped and uploaded to the lono managed s3 bucket. The files only get uploaded if they are referenced in your template with the `file_s3_url`.

## Lambda Function Example

The `app/files` are particularly useful for Lambda function resources.   Example:

```ruby
resource("Function", "AWS::Lambda::Function",
  Code: {
    S3Bucket: s3_bucket,
    S3Key: file_s3_key("index.rb"),
  },
  Handler: "index.lambda_handler",
  Role: get_att("LambdaExecutionRole.Arn"),
  Runtime: "ruby2.5",
  Timeout: "300"
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

## ERB Support

ERB is supported in app files. To activate ERB support, add a `.tt` extension to the file name. Lono will process the `.tt` files as ERB files and the `.tt` extension will be removed from the resulting final file.  Example:

app/files/index.rb.tt:

```ruby
require 'json'

def lambda_handler(event:, context:)
  # <%= "comment is from erb" %>
  { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end
```

Results in:

app/files/index.rb:

```ruby
require 'json'

def lambda_handler(event:, context:)
  # comment is from erb
  { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end
```

{% include prev_next.md %}
