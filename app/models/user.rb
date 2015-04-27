class User < ActiveRecord::Base
  has_secure_password

  belongs_to :guest
  has_one :invitation, through: :guest
  delegate :first_name, :last_name, to: :guest

  def self.authenticate(email, password)
    puts email
    user = find_by!(email: email)
    user.authenticate(password)
  end

  def can_rsvp_for?(guest)
    invitation.present? and invitation.guests.include?(guest)
  end
end
