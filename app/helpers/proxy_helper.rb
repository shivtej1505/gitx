# frozen_string_literal: true

module ProxyHelper
  # Only taking Accept & Authorization header. As Rack is mixing its own headers, it is a bit hacky to distinguish
  # between user defined & rails defined headers. Also, we can't ask user to only send Accept & Authorization headers
  # when they send other kind of headers due to the same reason.
  # Read more:
  # Headers with `HTTP_` prefix are user-generated headers https://stackoverflow.com/a/6318491/4657277
  def parse_headers(request)
    headers = {}
    %w[Accept Authorization].each do |key|
      next unless request.headers.key?(key)
      headers[key] = request.headers[key]
    end
    headers
  end

  # As Rails is adding its own keywords in params and we will never be sure of complete list,
  # we will need to update this code if the list changes in future
  def parse_query_params(params)
    query_params = {}
    params.each do |key, value|
      next if %w[controller action path].include?(key)
      query_params[key] = value
    end
    query_params
  end

  # What is the meaning of normalize here?
  # 1. We are downcase-ing given string
  # 2. We are converting it to symbol
  def normalize_method(method)
    unless method.is_a?(String)
      raise ArgumentError, "Invalid method type. Expected String, found #{method.class}"
    end
    method.downcase.to_sym
  end
end
