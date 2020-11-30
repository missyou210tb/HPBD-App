Rails.application.routes.draw do
  resources :admin do
    collection do
      get 'logins'
      post 'logins'
      post 'Clogins'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
