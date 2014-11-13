class User < ActiveRecord::Base
  has_secure_password

  # def password=(password)
  #   self.password_salt = SecureRandom.hex
  #   @password = BCrypt::Password.create("#{self.password_salt}#{password}")
  #   self.password_digest = @password
  # end
end
