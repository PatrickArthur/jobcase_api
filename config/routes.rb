Rails.application.routes.draw do
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  root 'jobs#index'
  resources :jobs, only: [:index, :show, :create]
  resources :search, only: [:index]
  resources :events, only: [:index]
end


