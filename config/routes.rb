Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope '/api' do
    post "/*path", to: "proxy#index"
    delete "/*path", to: "proxy#index"
    put "/*path", to: "proxy#index"
    post "/*path", to: "proxy#index"
    get "/*path", to: "proxy#index"
  end
end
