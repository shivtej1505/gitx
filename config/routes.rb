# frozen_string_literal: true

Rails.application.routes.draw do
  scope "/github/api" do
    get "/*path", to: "proxy#index"
    post "/*path", to: "proxy#index"
    put "/*path", to: "proxy#index"
    patch "/*path", to: "proxy#index"
    delete "/*path", to: "proxy#index"
  end

  get "/404", to: "errors#not_found"
  get "/500", to: "errors#server_error"
end
