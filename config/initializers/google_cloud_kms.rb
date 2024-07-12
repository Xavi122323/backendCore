require "google/cloud/kms"
require "json"

begin
  credentials = JSON.parse(ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'])
  Rails.logger.info("GOOGLE_APPLICATION_CREDENTIALS_JSON parsed successfully")
rescue JSON::ParserError => e
  Rails.logger.error("Failed to parse GOOGLE_APPLICATION_CREDENTIALS_JSON: #{e.message}")
  credentials = nil
end

if credentials
  Google::Cloud::Kms.configure do |config|
    config.credentials = credentials
  end
else
  Rails.logger.error("No valid GOOGLE_APPLICATION_CREDENTIALS_JSON found")
end
