class Guest < ActiveRecord::Base
  has_one :user
  belongs_to :invitation

  def self.find_by_email(email)
    email = email.downcase.strip
    Guest.where('trim(lower(email)) = ?', email).first
  end
end
