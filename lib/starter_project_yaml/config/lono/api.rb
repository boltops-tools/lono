template "api-web-prod.yml" do
  source "web.yml.erb"
  variables(
    ami: "ami-123",
    instance_type: "t2.small",
    port: "80",
    high_threshold: "15",
    high_periods: "4",
    low_threshold: "5",
    low_periods: "10",
    max_size: "24",
    min_size: "6",
    down_adjustment: "-3",
    up_adjustment: "3",
    ssl_cert: "arn:aws:iam::12345:server-certificate/wildcard"
  )
end

template "api-worker-prod.yml" do
  source "web.yml.erb"
  variables(
    ami: "ami-123",
    instance_type: "t2.small",
    port: "80",
    high_threshold: "15",
    high_periods: "4",
    low_threshold: "5",
    low_periods: "10",
    max_size: "24",
    min_size: "6",
    down_adjustment: "-3",
    up_adjustment: "3",
    user_data_script: "ruby_script.rb.erb",
    ssl_cert: "arn:aws:iam::12345:server-certificate/wildcard"
  )
end

template "api-redis-prod.yml" do
  source "db.yml.erb"
  variables(
    ami: "ami-456",
    instance_type: "t2.small",
    port: "80",
    volume_size: "20",
    availability_zone: "us-east-1e"
  )
end

template "parent/db-stack.yml" do
  source "db.yml.erb"
  variables(
    ami: "ami-456",
    instance_type: "t2.small",
    port: "80",
    volume_size: "20",
    availability_zone: "us-east-1e"
  )
end
