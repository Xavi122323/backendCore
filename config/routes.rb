Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index" 
  
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      root "servidor#index"
      resources :servidores, only:[:index, :show, :create, :update, :destroy]
      
    end
  end
end
