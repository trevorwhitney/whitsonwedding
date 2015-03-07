class Guest < ActiveRecord::Base
  has_one :user
  belongs_to :invitation
end
