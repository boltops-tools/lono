template "example"

template "api-web" do
  source "web"
  variables(
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

template "api-worker" do
  source "web"
  variables(
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
    user_data_script: "ruby_script.rb",
    ssl_cert: "arn:aws:iam::12345:server-certificate/wildcard"
  )
end

template "api-redis" do
  source "db"
  variables(
    instance_type: "t2.small",
    port: "80",
    volume_size: "20",
    availability_zone: "us-east-1e"
  )
end

template "parent/db-stack" do
  source "db"
  variables(
    instance_type: "t2.small",
    port: "80",
    volume_size: "20",
    availability_zone: "us-east-1e"
  )
end
