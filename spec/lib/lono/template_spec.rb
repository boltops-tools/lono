require File.expand_path("../../../spec_helper", __FILE__)

describe Lono::Template do
  let(:template) do
    block = Proc.new {}
    template = Lono::Template.new("output_name.yml", block)

    # override the puts and printf methods within the test
    def template.messages
      @messages
    end

    def template.puts(msg)
      @messages ||= []
      @messages << msg
      nil
    end

    def template.printf(*args)
      @messages ||= []
      @messages << args
    end

    template
  end

  context "valid erb template" do
    it "should be able to lono generate" do
      template.erb_result("path", "template")
    end
  end

  context "invalid erb template" do
    it "should print out useful error message about undefined variable" do
      template.erb_result("path", "variable does not exist\n<% variable %>\nanother line")
      errors = template.messages.grep(/Error evaluating ERB template on line/)
      expect(errors).not_to be_empty
    end

    it "should print out useful error message about syntax error" do
      template.erb_result("path", "<%s dsfds ?%>\nanother line")
      errors = template.messages.grep(/Error evaluating ERB template on line/)
      expect(errors).not_to be_empty
    end
  end
end
