# frozen_string_literal: true

# TODO: Should we keep this function inside a module??
def request_params
  endpoint = FactoryBot.build(:endpoint)
  request_headers = FactoryBot.build(:headers)
  [
    endpoint,
    request_headers
  ]
end

def base_url_generator
  url = Faker::Internet.url
  url.gsub(/\/[a-zA-Z0-9]+$/, "") # what are we doing here? We are removing anything after last `/`
end

def stub_request_with_base_url(method, base_url, endpoint)
  unless method.is_a?(Symbol)
    raise ArgumentError, "Invalid method type. Expected Symbol, found #{method.class}"
  end
  stub_request(method, "#{base_url}/#{endpoint}")
end
