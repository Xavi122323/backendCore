class KmsService
  PROJECT_ID = 'kmsseguridad'
  LOCATION = 'southamerica-west1'
  KEYRING = 'keys_seguridad'
  KEY = 'key_seguridad'

  def self.kms_client
    @kms_client ||= Google::Cloud::Kms.key_management_service
  end

  def self.crypto_key_path
    kms_client.crypto_key_path PROJECT_ID, LOCATION, KEYRING, KEY
  end

  def self.encrypt(plaintext)
    response = kms_client.encrypt crypto_key_path, plaintext
    response.ciphertext
  end

  def self.decrypt(ciphertext)
    response = kms_client.decrypt crypto_key_path, ciphertext
    response.plaintext
  end
end