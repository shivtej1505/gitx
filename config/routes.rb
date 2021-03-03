# frozen_string_literal: true

Rails.application.routes.draw do
  # TODO: Only allow Git endpoints for now and block others??
  # Do I need to specify content-type? (format: json) or is it not required?
  # Versioning??
  scope "/api" do
    get "/*path", to: "proxy#index"
    post "/*path", to: "proxy#index"
    put "/*path", to: "proxy#index"
    patch "/*path", to: "proxy#index"
    delete "/*path", to: "proxy#index"
  end

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#server_error'
end
