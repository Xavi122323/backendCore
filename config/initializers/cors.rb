# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      #origins "http://localhost:4200"
      origins "https://frontend-core-7tveg0onm-xavi122323s-projects.vercel.app"
 
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
    end
  end
