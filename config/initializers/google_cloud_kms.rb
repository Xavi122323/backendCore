# config/initializers/google_cloud_kms.rb
require "google/cloud/kms"

credentials_json = ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']
Google::Cloud::Kms.configure do |config|
  config.credentials = JSON.parse(credentials_json)
end