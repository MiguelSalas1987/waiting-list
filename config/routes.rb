Rails.application.routes.draw do

  resources :requests, only: [:index,:new, :create, :show]
  resources :email_confirmations, only: [:edit]

  get 'email_confirmations/:id/reconfirm', to: 'email_confirmations#reconfirm', as: 'reconfirm'
  root to: 'requests#new'

end
