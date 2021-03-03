# frozen_string_literal: true

class ProxyController < ActionController::API
  include ProxyHelper

  def index
    git = Git::Session.new
    proxy_request_params = generate_proxy_request_params
    response = git.make_request(proxy_request_params)
    render json: response.body, status: response.status
  end

  private

  # Constructing proxy_request params
  def generate_proxy_request_params
    {
      endpoint: params[:path],
      method: normalize_method(request.method),
      body: request.raw_post, # Pass whatever body you get from the request
      headers: parse_headers(request),
      params: parse_query_params(params)
    }
  end
end
