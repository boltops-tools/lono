template "prod-api-app.json" do
  source "app.json.erb"
  variables(
    :env => 'prod',
    :app => 'api',
    :role => "app",
    :ami => "ami-123",
    :instance_type => "c1.xlarge",
    :port => "80",
    :high_threshold => "15",
    :high_periods => "4",
    :low_threshold => "5",
    :low_periods => "10",
    :max_size => "24",
    :min_size => "6",
    :down_adjustment => "-3",
    :up_adjustment => "3",
    :ssl_cert => "arn:aws:iam::12345:server-certificate/wildcard"
  )
end