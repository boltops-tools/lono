class Lono::Files::Builder::LambdaLayer
  class RubyVersion < Lono::Files::Base
    def initialize(options={})
      # cfn passed from Finalizer::Files::Build#build_files to
      # Lono::Files#build_lambda_layer(@cfn)
      # This because Lono::Files at initialization only has registration info
      # The build info is passed to the build_lambda_layer method
      @cfn = options[:cfn]
      super
    end

    def check!
      # IE: logical_id = LayerVersion
      # attrs = attrs with attrs['Properties']
      logical_id, attrs = @cfn['Resources'].find do |logical_id, attrs|
        attrs.dig('Properties', 'Content', 'S3Key') == @files.marker
      end
      props = attrs['Properties']
      major, minor, _ = RUBY_VERSION.split('.')
      current_ruby = "ruby#{major}.#{minor}"
      ok = props['CompatibleRuntimes'].include?(current_ruby)
      return if ok

      runtimes = props['CompatibleRuntimes'].map { |s| s.sub('ruby','') }.join(', ')
      logger.error "ERROR: Current Ruby Version does not match the Lambda Layer Ruby Version".color(:red)
      logger.error <<~EOL
        Current Ruby: #{RUBY_VERSION}
        Lambda Layer Ruby Version: #{runtimes}

        Lono is unable to package up a Lambda Layer
        unless you use the same Ruby version on this machine.
      EOL
      logger.error "Resource: #{logical_id}"
      logger.error YAML.dump(attrs)
      exit 1
    end
  end
end
