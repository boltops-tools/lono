require 'base64'
require 'json'
require 'net/http'

class Lono::Importer::Service::Coder
  def initialize(template, options={})
    @template, @options = template, options
  end

  def translate
    url = "#{Lono::API}/code"
    http = net_http_client(url)
    req = net_http_request(url,
      template: Base64.encode64(@template), # Base64 JSON for special chars that Rack::LintWrapper cannot process
      lono_version: Lono::VERSION,
      lono_command: lono_command,
    )
    res = http.request(req) # send request

    if res.code == "200"
      data = JSON.load(res.body)
      ruby_code = print(data) # returns data["ruby_code"] / passthrough
      ruby_code
    else
      puts "Error: Unable to convert template to Ruby code."
      puts "The error has been reported."
      puts "Non-successful http response status code: #{res.code}"
      # puts "headers: #{res.each_header.to_h.inspect}"
      exit 1
    end
  end

private
  def print(data)
    return if ENV['LONO_PRO_TEST']

    if data["error"]
      # Code was processed but there was this error with an HTTP 200 OK
      $stderr.puts "ERROR: #{data["error"]}".color(:red)
      if data["message"]
        $stderr.puts data["message"]
      end
      return
    end

    validity = data["valid_ruby"] ? "valid" : "invalid"
    if validity == "valid"
      $stderr.puts "INFO: The generated Ruby code is has #{validity} syntax."
    else
      $stderr.puts "WARN: The generated Ruby code is has #{validity} syntax. Providing because it may be small errors.".color(:yellow) # note redirection disables color
    end

    $stderr.puts <<~EOL
      Translated ruby code below:

    EOL
    ruby_code = data["ruby_code"]
    puts ruby_code
    ruby_code
  end

  def net_http_client(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = http.read_timeout = 30
    http.use_ssl = true if uri.scheme == 'https'
    http
  end

  def net_http_request(url, data)
    req = Net::HTTP::Post.new(url) # url includes query string and uri.path does not, must used url
    text = JSON.dump(data)
    req.body = text
    req.content_length = text.bytesize
    req
  end

  def lono_command
    "#{$0} #{ARGV.join(' ')}"
  end
end
