# frozen_string_literal: true

Rails.application.routes.draw do
  # TODO: Only allow Git endpoints for now and block others??
  scope "/api" do
    get "/*path", to: "proxy#index"
    post "/*path", to: "proxy#index"
    put "/*path", to: "proxy#index"
    patch "/*path", to: "proxy#index"
    delete "/*path", to: "proxy#index"
  end
end
