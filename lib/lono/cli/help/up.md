## Examples

    $ lono up demo
    Deploying demo-dev stack
    Building template
        output/demo/template.yml
    Uploading template
    Not modified: output/demo/template.yml to s3://lono-bucket-12di8xz5sy72z/dev/output/demo/template.yml
    Uploaded to s3.
    Building parameters
        output/demo/params.json
    Going to create stack demo-dev with blueprint demo. (y/N) y
    Parameters passed to create_stack:
    ---
    disable_rollback: false
    parameters:
    - parameter_key: AccessControl
      parameter_value: PublicRead
    stack_name: demo-dev
    template_url: https://lono-bucket-12di8xz5sy72z.s3.us-west-2.amazonaws.com/dev/output/demo/template.yml
    Waiting for stack to complete
    05:07:26AM CREATE_IN_PROGRESS AWS::CloudFormation::Stack demo-dev User Initiated
    05:07:30AM CREATE_IN_PROGRESS AWS::S3::Bucket Bucket
    05:07:31AM CREATE_IN_PROGRESS AWS::S3::Bucket Bucket Resource creation Initiated
    05:07:52AM CREATE_COMPLETE AWS::S3::Bucket Bucket
    05:07:53AM CREATE_COMPLETE AWS::CloudFormation::Stack demo-dev
    Stack success status: CREATE_COMPLETE
    Time took: 30s.
    Create demo-dev stack.
    $
