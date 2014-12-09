Rails.application.routes.draw do
  root 'home#index'

  namespace :api do
    post :invoice
  end
end
