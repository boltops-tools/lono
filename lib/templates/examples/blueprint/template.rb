parameter("BucketName", Conditional: true)
parameter("AccessControl", Default: "Private")

resource("Bucket", "AWS::S3::Bucket",
  BucketName: ref("BucketName", Conditional: true),
  AccessControl: ref("AccessControl"),
)

output("BucketName", ref("Bucket"))
