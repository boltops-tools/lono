template "prod-blog-app.json" do
  env,app,role = name.sub('.json','').split('-')
  source "app.json.erb"
  variables(
    env: env,
    app: app,
    role: role,
    ami: "ami-456",
    instance_type: "m1.small",
    port: "80",
    high_threshold: "35",
    high_periods: "4",
    low_threshold: "20",
    low_periods: "2",
    max_size: "6",
    min_size: "3",
    down_adjustment: "-1",
    up_adjustment: "2"
  )
end
