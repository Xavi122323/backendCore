# config/initializers/google_cloud_kms.rb
require "google/cloud/kms"

Google::Cloud::Kms.configure do |config|
  config.credentials = JSON.parse(ENV['GOOGLE_APPLICATION_CREDENTIALS'])
end