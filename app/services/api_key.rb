module ApiKey
  def self.generator
    SecureRandom.urlsafe_base64
  end
end
