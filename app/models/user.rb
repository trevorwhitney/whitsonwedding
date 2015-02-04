class User < ActiveRecord::Base
  has_secure_password

  belongs_to :guest
  delegate :first_name, :last_name, to: :guest
end
