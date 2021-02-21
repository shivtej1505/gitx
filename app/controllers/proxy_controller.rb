class ProxyController < ActionController::API
  include ProxyHelper

  def index
    git = Git::Session.new
    response = git.do_request(parse_proxy_params(request, params))
    response_body = parse_response_body(response)
    render json: response_body, status: response.code.to_i
  end

  private
  def parse_proxy_params(request, params)
    {
      endpoint: params[:path],
      method: request.method,
      body: parse_body(request),
      headers: parse_headers(request),
      opts: parse_opts(params)
    }
  end
end
