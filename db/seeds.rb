# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#

guests = [
 {
  email: 'trevorjwhitney@gmail.com',
  first_name: 'Trevor',
  last_name: 'Whitney'
 }
]

guests.each do |user|
  Guest.create(email: user[:email], first_name: user[:first_name], last_name: user[:last_name])
end
