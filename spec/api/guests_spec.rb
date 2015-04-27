require 'rails_helper'

describe GuestsController do
  before do
    invitation = Invitation.create
    @john_guest = Guest.create(
      first_name: 'John',
      last_name: 'Smith',
      invitation: invitation
    )
    @sally_guest = Guest.create(
      first_name: 'Sally',
      last_name: 'Fields',
      invitation: invitation
    )
    @john_user = User.create(
      guest: @john_guest,
      email: 'john@example.com',
      password: 'secret',
      password_confirmation: 'secret'
    )

    post '/login', email: 'john@example.com', password: 'secret'
    expect(response).to have_http_status(:ok)
    @access_token = JSON.parse(response.body)['access_token']
  end

  describe 'GET #index' do
    it 'gets a list of guests on the same invitation as a user' do
      post '/login', email: 'john@example.com', password: 'secret'
      expect(response).to have_http_status(:ok)

      get "/users/#{@john_user.id}/guests", access_token: @access_token
      expect(response).to have_http_status(:ok)
      guests = JSON.parse(response.body)
      expect(guests.size).to eq 2

      john_guest = guests.find {|g| g['first_name'] == 'John'}
      sally_guest = guests.find {|g| g['first_name'] == 'Sally'}

      expect(john_guest['first_name']).to eq 'John'
      expect(john_guest['last_name']).to eq 'Smith'

      expect(sally_guest['first_name']).to eq 'Sally'
      expect(sally_guest['last_name']).to eq 'Fields'
    end
  end

  describe '#update' do
    it 'allows a guest to update their rsvp' do
      put "/guests/#{@john_guest.id}", rsvp: true, access_token: @access_token
      expect(response).to have_http_status(:ok)
      expect(@john_guest.reload.rsvp).to eq true
    end

    it 'only allows a user to rsvp for guests on their invitation' do
      invitation = Invitation.create
      other_guest = Guest.create(
        first_name: 'Other',
        last_name: 'Guest',
        invitation: invitation
      )

      put "/guests/#{other_guest.id}", rsvp: true, access_token: @access_token
      expect(response).to have_http_status(:bad_request)

      put "/guests/#{@john_guest.id}", rsvp: true, access_token: @access_token
      expect(response).to have_http_status(:ok)
    end
  end
end
