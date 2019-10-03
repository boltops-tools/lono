module Lono::Help
  class << self
    # namespaced_command: cfn/create or cfn:create both work.
    def text(namespaced_command)
      path = namespaced_command.to_s.gsub(':','/')
      path = File.expand_path("../help/#{path}.md", __FILE__)
      IO.read(path) if File.exist?(path)
    end

    # Generates a markdown file for site docuemtation
    def markdown

    end
  end
end
