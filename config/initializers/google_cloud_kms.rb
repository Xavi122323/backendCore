require "google/cloud/kms"
require "json"

credentials_json = ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']

if credentials_json.present?
  begin
    credentials = JSON.parse(credentials_json)
    Rails.logger.info("GOOGLE_APPLICATION_CREDENTIALS_JSON parsed successfully")

    Google::Cloud::Kms.configure do |config|
      config.credentials = credentials
    end

    Rails.logger.info("Google Cloud KMS configured successfully")
  rescue JSON::ParserError => e
    Rails.logger.error("Failed to parse GOOGLE_APPLICATION_CREDENTIALS_JSON: #{e.message}")
  rescue => e
    Rails.logger.error("Failed to configure Google Cloud KMS: #{e.message}")
  end
else
  Rails.logger.error("GOOGLE_APPLICATION_CREDENTIALS_JSON not set or empty")
end
