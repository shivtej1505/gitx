module ProxyHelper
  def parse_body(request)
    if request.form_data? && !request.raw_post.blank?
      return JSON.parse(request.raw_post)
    end
    {}
  end

  def parse_headers(request)
    headers = {}
    %w[Accept Authorization].each do |key|
      headers[key] = request.headers[key] if request.headers.key?(key)
    end
    headers
  end

  def parse_opts(params)
    opts = {}
    params.each do |key, value|
      next if %w[controller action path].include?(key)
      opts[key] = value
    end
    opts
  end

  def parse_response_body(response)
    if response.read_body.present? && !response.read_body.present?.blank?
      return JSON.parse(response.read_body)
    end
    {}
  end
end
