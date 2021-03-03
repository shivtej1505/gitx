# frozen_string_literal: true

module ProxyHelper
  # Only taking Accept & Authorization header
  # As Rails is mixing its own headers, it is not possible to distinguish between user defined & rails defined headers
  def parse_headers(request)
    headers = {}
    # is it mutability?
    %w[Accept Authorization].each do |key|
      headers[key] = request.headers[key] if request.headers.key?(key)
    end
    headers
  end

  # As Rails is adding its own keywords in params and we will never be sure of complete list,
  # we will need to update this code if the list changes in future
  def parse_query_params(params)
    query_params = {}
    # is it mutability?
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
    # Is it mutation?
    method.downcase.to_sym
  end
end
