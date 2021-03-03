# frozen_string_literal: true

class ProxyController < ActionController::API
  include ProxyHelper

  def index
    git = Git::Session.new
    response = git.make_request(proxy_request_params)
    render json: response.body, status: response.status
  end

  private
  # TODO: Can we directly pass request to Git::Session & let it figure out stuff?
  # we are actually parsing request & params to get what we need
  def proxy_request_params
    {
      endpoint: params[:path],
      method: normalize_method(request.method),
      body: request.raw_post, # Pass whatever body you get from request
      headers: parse_headers(request),
      params: parse_query_params(params)
    }
  end
end
