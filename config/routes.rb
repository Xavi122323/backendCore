Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    registrations: :registrations,
    sessions: :sessions
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index" 

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      root "servidor#index"
      resources :servidor, only:[:index, :show, :create, :update, :destroy]
      resources :admin_role, only:[:index, :show, :create, :update, :destroy]
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"
      end
    end
  end
end
