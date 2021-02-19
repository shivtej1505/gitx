class ProxyController < ActionController::API
  def index
    endpoint = params[:path]
    method = request.method
    body = request.form_data? ? JSON.parse(request.raw_post) : {}
    headers = {}
    %w[Accept Authorization].each do |key|
      headers[key] = request.headers[key]
    end

    git = Git::Session.new
    response = git.do_request(endpoint: endpoint, method: method, body: body, headers: headers)
    response_body = response.read_body.present? ? JSON.parse(response.read_body) : {}
    render json: response_body, status: response.code.to_i
  end
end
