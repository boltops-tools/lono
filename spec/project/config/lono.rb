template "prod-br-app.json" do
  source "app.json.erb"
  variables(
    :env => "prod",
    :app => 'br',
    :role => "app",
    :ami => "ami-456",
    :instance_type => "m1.medium",
    :port => "80",
    :high_threshold => "35",
    :high_periods => "4",
    :low_threshold => "20",
    :low_periods => "2",
    :max_size => "6",
    :min_size => "3",
    :down_adjustment => "-1",
    :up_adjustment => "2"
  )
end