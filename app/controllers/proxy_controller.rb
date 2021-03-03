# frozen_string_literal: true

class ProxyController < ActionController::API
  include ProxyHelper

  def index
    git = Git::Session.new
    response = git.make_request(parse_proxy_params(request, params))
    render json: response.body, status: response.status
  end

  private

  def parse_proxy_params(request, params)
    {
      endpoint: params[:path],
      method: request.method.downcase.to_sym, # Is downcasing & to_sym cool?
      body: JSON.generate(parse_body(request)), # not so good way I guess
      headers: parse_headers(request),
      params: parse_opts(params)
    }
  end
end
