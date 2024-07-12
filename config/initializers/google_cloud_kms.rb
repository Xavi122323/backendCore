require "google/cloud/kms"
require "json"

Rails.logger.info("GOOGLE_APPLICATION_CREDENTIALS_JSON: #{ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']}")

Google::Cloud::Kms.configure do |config|
  config.credentials = JSON.parse(ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'])
end