
Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'
  mount Sidekiq::Web => '/sidekiq'
  devise_for :admins,
  path: 'admin',
    path_names: {sign_in: 'login', sign_out: 'logout'}
  resources :admin do
    get 'create_user', on: :collection
    post 'post_user', on: :collection
  end
  resources :home
  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
