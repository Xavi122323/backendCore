# app/services/kms_service.rb
require "google/cloud/kms"
require "base64"

class KmsService
  PROJECT_ID = 'kmsseguridad'
  LOCATION = 'southamerica-west1'
  KEYRING = 'keys_seguridad'
  KEY = 'key_seguridad'

  def self.kms_client
    @kms_client ||= Google::Cloud::Kms.key_management_service
  end

  def self.crypto_key_path
    kms_client.crypto_key_path project: PROJECT_ID, location: LOCATION, key_ring: KEYRING, crypto_key: KEY
  end

  def self.encrypt(plaintext)
    response = kms_client.encrypt name: crypto_key_path, plaintext: plaintext
    Base64.strict_encode64(response.ciphertext)
  end

  def self.decrypt(ciphertext)
    decoded_ciphertext = Base64.strict_decode64(ciphertext)
    response = kms_client.decrypt name: crypto_key_path, ciphertext: decoded_ciphertext
    response.plaintext
  end
end
