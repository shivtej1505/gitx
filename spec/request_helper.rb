def all_verbs
  [:get, :put, :post, :delete, :patch]
end

def post_kind_verbs
  [:put, :post, :delete, :patch]
end

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
  url.gsub(/\/[a-zA-Z0-9]+$/, "")
end

def stub_request_with_base_url(method, base_url, endpoint)
  stub_request(method, "#{base_url}/#{endpoint}")
end
