class Guest < ActiveRecord::Base
  has_one :user
end
