Rails.application.routes.draw do

  resources :requests, only: [:index,:new, :create, :show]
  resources :email_confirmations, only: [:edit]

end
