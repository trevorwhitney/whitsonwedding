Guest.connection.execute('truncate guests restart identity cascade')

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
