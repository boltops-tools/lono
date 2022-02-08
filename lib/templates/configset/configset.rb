configset("config1") do
  command("test",
    command: 'echo "$CFNTEST" > test1.txt',
    env: {
      CFNTEST: "I come from config1"
    }
  )
end
configset("config2") do
  command("test",
    command: 'echo "$CFNTEST" > test2.txt',
    env: {
      CFNTEST: "I come from config2"
    }
  )
end
