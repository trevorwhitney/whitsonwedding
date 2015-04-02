require 'rails_helper'

module Api
  describe 'creating a user' do
    it 'only allows a user to create an account if their email matches that of a guest' do
      post '/sign_up', email: 'bjones@example.com', password: 'secret'
      expect(last_response.status).to eq 400
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response['email']).to eq 'bjones@example.com'
      expect(parsed_response['errors']['email']).
        to match_array(['does not match any emails we have on our guest list. ' +
                        "Maybe we have a different email for you? If you've tried them all, please let Trevor " +
                        'know at trevorjwhitney@gmail.com.'
        ])

      invitation = Invitation.create!
      guest = Guest.create!(first_name: 'Bob', last_name: 'Jones', email: 'bjones@example.com', invitation: invitation)
      post '/sign_up', email: 'bjones@example.com', password: 'secret'
      expect(last_response.status).to eq 200

      user = User.last
      expect(user.email).to eq 'bjones@example.com'
      expect(user.first_name).to eq 'Bob'
      expect(user.last_name).to eq 'Jones'
      expect(user.guest.id).to eq guest.id
    end

    it 'signs the user in, returning an authorization key, on accout creation' do
      invitation = Invitation.create!
      Guest.create!(first_name: 'Bob', last_name: 'Jones', email: 'bjones@example.com', invitation: invitation)
      post '/sign_up', email: 'bjones@example.com', password: 'secret'
      expect(last_response.status).to eq 200

      session = Session.last
      parsed_response = JSON.parse(last_response.body)
      expect(parsed_response['access_token']).to eq session.access_token
    end
  end
end
