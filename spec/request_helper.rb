# frozen_string_literal: true

def request_params
  endpoint = FactoryBot.build(:endpoint)
  request_headers = FactoryBot.build(:headers)
  [
    endpoint,
    request_headers
  ]
end

def base_url_generator
  # Should we test for both http & https?
  # No, we are not testing Faraday, we are testing our code. It is out of scope
  url = Faker::Internet.url(scheme: "https")
  url.gsub(/\/[a-zA-Z0-9]+$/, "")
end

def stub_request_with_base_url(method, base_url, endpoint)
  unless method.is_a?(Symbol)
    raise ArgumentError, "Invalid method type. Expected Symbol, found #{method.class}"
  end
  stub_request(method, "#{base_url}/#{endpoint}")
end
