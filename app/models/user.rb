class User < ActiveRecord::Base
  has_secure_password

  belongs_to :guest
  delegate :first_name, :last_name, to: :guest

  def self.authenticate(email, password)
    puts email
    user = find_by!(email: email)
    user.authenticate(password)
  end
end
