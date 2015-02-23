guests = [
 {
  email: 'trevorjwhitney@gmail.com',
  first_name: 'Trevor',
  last_name: 'Whitney'
 }
]

existing_guests = Guest.all.pluck(:email)

guests.each do |user|
  Guest.create(
    email: user[:email], 
    first_name: user[:first_name], 
    last_name: user[:last_name]
  ) unless existing_guests.include?(user[:email])
end
