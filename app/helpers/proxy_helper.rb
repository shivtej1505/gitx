# frozen_string_literal: true

module ProxyHelper
  def parse_body(request)
    if request.form_data? && !request.raw_post.blank?
      return JSON.parse(request.raw_post)
    end
    {}
  end

  def parse_headers(request)
    headers = {}
    # TODO: Only taking these headers? Don't think this is good
    %w[Accept Authorization].each do |key|
      headers[key] = request.headers[key] if request.headers.key?(key)
    end
    headers
  end

  def parse_opts(params)
    opts = {}
    params.each do |key, value|
      # TODO: What if in new Rails version they add more keyword with request. Then we need to change this code, right?
      next if %w[controller action path].include?(key)
      opts[key] = value
    end
    opts
  end

  def parse_response_body(response)
    if response.read_body.present? && !response.read_body.blank?
      return JSON.parse(response.read_body)
    end
    {}
  end
end
