# frozen_string_literal: true

class ErrorsController < ActionController::API
  def not_found
    render json: {
      message: "Not Found"
    }, status: :not_found
  end

  def server_error
    render json: {
      message: "An internal error occurred. Please try later"
    }, status: :internal_server_error
  end
end
