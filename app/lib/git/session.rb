module Git
  class Session
    def initialize
      @token = "072f611f44a2da38993e1353fd12fa5e4f2f1e18"
      @url = "https://api.github.com"
    end

    def do_request(endpoint:, method:, body: {}, opts: {}, headers: {})
      uri = create_uri(endpoint, opts)
      http = create_http(uri)
      request = create_request(uri, method: method, body: body)
      http.request(request)
    end

    private

    def create_uri(endpoint, opts = {})
      url = "#{@url}/#{endpoint}#{opts_url(opts)}"
      URI(url)
    end

    def create_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end

    def create_request(uri, method:, body: nil)
      request = "Net::HTTP::#{method.capitalize}".constantize.new(uri)
      request["Accept"] = "application/vnd.github.v3+json"
      request["Authorization"] = "token #{@token}"
      if body.present?
        request["Content-Type"] = "application/json"
        request.body = body.to_json
      end
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
  end
end
