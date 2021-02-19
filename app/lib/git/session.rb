module Git
  class Session
    def initialize
      @username = "shivtej1505"
      @token = "072f611f44a2da38993e1353fd12fa5e4f2f1e18"
      @url = "https://api.github.com"
      super
    end

    def repos(page, per_page: 100)
      endpoint = "#{@url}/users/#{@username}/repos?page=#{page}&per_page=#{per_page}"

      url = URI(endpoint)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request["Accept"] = "application/vnd.github.v3+json"

      response = http.request(request)

      parse_body(response)
    end

    private

    def parse_body(response, format: :json)
      if format == :json
        JSON.parse(response.read_body)
      end
    end
  end
end
