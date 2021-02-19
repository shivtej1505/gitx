class ProxyController < ActionController::API
  # TODO:
  # how to pass headers

  def index
    puts params[:path]
    endpoint = params[:path]
    method = request.method
    body = request.form_data? ? JSON.parse(request.raw_post) : {}

    git = Git::Session.new
    response = git.do_request(endpoint: endpoint, method: method, body: body)
    response_body = response.read_body.present? ? JSON.parse(response.read_body) : {}
    render json: response_body, status: response.code.to_i
  end
end
