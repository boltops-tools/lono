require 'net/http'
require 'open-uri'

module Lono::Bundler::Component::Http
  class Source
    include LB::Util::Logging
    include Concern

    def initialize(params)
      @params = params
      @options = params[:options]
      @source = @options[:source]
    end

    def url
      @source
    end
  end
end
