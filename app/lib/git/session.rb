module Git
  class Session
    def initialize
      @username = "shivtej1505"
      @token = "072f611f44a2da38993e1353fd12fa5e4f2f1e18"
      @url = "https://api.github.com"
      super
    end

    def repos(page, per_page: 100)
      opts = {
        page: page,
        per_page: per_page
      }
      uri = create_uri("users/#{@username}/repos", opts)
      http = create_http(uri)
      request = create_request(uri, method: :get)
      response = http.request(request)
      parse_body(response)
    end

    def create_repo(name)
      uri = create_uri("user/repos")
      http = create_http(uri)
      request = create_request(uri, method: :post, body: {name: name})
      response = http.request(request)
      parse_body(response)
    end

    private

    def create_uri(endpoint, opts = {})
      url = "#{@url}/#{endpoint}?"
      opts.each do |key, value|
        url += "#{key}=#{value}&"
      end
      puts url
      puts "---"
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
        request['Content-Type'] = 'application/json'
        request.body = body.to_json
      end
      request
    end

    def parse_body(response, format: :json)
      if format == :json
        JSON.parse(response.read_body)
      end
    end
  end
end
