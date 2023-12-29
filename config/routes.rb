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
      resources :componente, only:[:index, :show, :create, :update, :destroy]
      resources :database, only:[:index, :show, :create, :update, :destroy]
      resources :metrica, only:[:index, :show, :create, :update, :destroy]
      resources :consultas, only:[:index, :show, :create, :update, :destroy, :uso_cpu_promedio]
      get 'uso_cpu_promedio', to: 'consultas#uso_cpu_promedio'
      get 'cpu_fechas', to: 'consultas#cpu_fechas'
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"
      end
    end
  end
end
