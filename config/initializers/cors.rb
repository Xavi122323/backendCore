# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins "http://localhost:4200", "frontend-core-blue.vercel.app", 
      "frontend-core-git-master-xavi122323s-projects.vercel.app", 
      "frontend-core-q44aeqw2q-xavi122323s-projects.vercel.app",
      "https://adrianbedon.github.io/front-react/",
      "https://adrianbedon.github.io"
 
      resource "*",
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
      resource '/api/v1/servidor',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
      resource '/api/v1/sessions',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
      resource '/api/v1/registrations',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
      resource '/api/v1/admin_role',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
      resource '/api/v1/componente',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
      resource '/api/v1/database',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
      resource '/api/v1/metrica',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
      resource '/api/v1/consultas',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end
