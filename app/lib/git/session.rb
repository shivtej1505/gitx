module Git
  class Session
    def initialize
      @base_url = "https://api.github.com"
    end

    def do_request(endpoint:, method:, body: {}, opts: {}, headers: {})
      uri = create_uri(endpoint, opts)
      http = create_http(uri)
      request = create_request(uri, method: method, body: body, headers: headers)
      http.request(request)
    end

    private

    def create_uri(endpoint, opts = {})
      url = "#{@base_url}/#{endpoint}#{opts_url(opts)}"
      URI(url)
    end

    def create_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end

    def create_request(uri, method:, body: nil, headers: {})
      request = "Net::HTTP::#{method.capitalize}".constantize.new(uri)
      request = add_headers(request, headers)
      request = add_body(request, body)
      request
    end

    def opts_url(opts)
      url = ""
      if opts.present?
        opts_url = "?"
        opts.each do |key, value|
          opts_url += "#{key}=#{value}&"
        end
      end
      url
    end

    def add_headers(request, headers = {})
      headers.each do |key, value|
        request[key] = value
      end
      request
    end

    def add_body(request, body = nil)
      if body.present?
        request["Content-Type"] = "application/json"
        request.body = body.to_json
      end
      request
    end
  end
end
