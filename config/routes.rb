Rails.application.routes.draw do
  resources :admin do
    collection do
      get 'logins'
      post 'logins'
      post 'clogins'
    end
  end
  resources :registers
  resources :logins
  resources :events
  resources :home
  get 'logout', to: 'logins#destroy', as: 'logout' 
  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
