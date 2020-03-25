---
title: Lambda Layers
categories: extras
nav_order: 94
---

Lono supports building and uploading Ruby Gem Lambda Layers.  Here's an example Lambda function and Gemfile to demonstrate how lono helps with building Lambda layers.

app/files/lambda-function/index.rb:

```ruby
def lambda_handler(event:, context:)
  puts "event: #{JSON.dump(event)}"
  puts "context: #{JSON.dump(context)}"
  {message: "hello world"}
end
```

app/files/lambda-function/Gemfile

```ruby
source "https://rubygems.org"
gem "s3-secure" # just an example gem - Lambda Layer cannot be empty and requires at least one gem
```

Then we'll create the Lambda function and layer.

app/templates/demo.rb:

```ruby
resource("Function", "AWS::Lambda::Function",
  Code: {
    S3Bucket: s3_bucket,
    S3Key: s3_key("lambda-function/"), # maps to app/files/lambda-function
  },
  Description: "Lambda Function",
  Handler: "index.lambda_handler",
  Layers: [ref("LayerVersion")],
  Role: get_att("LambdaExecutionRole.Arn"),
  Runtime: "ruby2.7",
  Timeout: "300",
)

resource("LayerVersion", "AWS::Lambda::LayerVersion",
  CompatibleRuntimes: ["ruby2.7"],
  Content: {
    S3Bucket: s3_bucket,
    S3Key: s3_key("lambda-function/", type: "lambda_layer", lang: "ruby") # type: "lambda_layer" results in autobuilding the layer using the Gemfile.lock
  },
  Description: "lambda layer",
  LayerName: "lambda-layer", # if not named, then it defaults to the logical id
  LicenseInfo: "Nonstandard"
)
```

We specify `s3_key("lambda-function/", type: "lambda_layer", lang: "ruby")` using the same folder where the `index.rb` Ruby code and `Gemfile` is located. This tells lono to use the Gemfile in that folder to build the Lambda Layer.

IMPORANT: Make sure to run `bundle` in the `app/files/lambda-function` folder to generate an updated `Gemfile.lock` file.

## Lambda Layers for Other Languages

Lono currently does not automatically build Lambda Layers for other languages to the same degree of convenience as Ruby. For other languages, add the files directly to the `app/files` folder. Lono automatically uploads files in that directory so you can use it in a Lambda Layer. Example:

app/templates/demo.rb:

```ruby
resource("LayerVersion", "AWS::Lambda::LayerVersion",
  CompatibleRuntimes: ["python3.8"],
  Content: {
    S3Bucket: s3_bucket,
    S3Key: s3_key("python-layer/") # no type so it doesnt trigger the lambda layer autobuilding
  },
  Description: "python layer",
  LayerName: "python-layer", # if not named, then it defaults to the logical id
  LicenseInfo: "Nonstandard"
)
```

You can add the lambda layer files in the `app/files/python-layer/` folder.

{% include prev_next.md %}
