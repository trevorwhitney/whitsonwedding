require 'rails_helper'

describe 'logging in and out' do
  before do
    invitation = Invitation.create
    guest = Guest.create!(first_name: 'Bob', last_name: 'Test', email: 'test@example.com', invitation: invitation)
    User.create!(email: 'test@example.com', password: 'secret', guest_id: guest.id)
  end

  it 'allows a user to login, returning the logged in users info' do
    post '/login', email: 'test@example.com', password: 'secret'
    expect(last_response.status).to eq 200
    parsed_response = JSON.parse(last_response.body)
    expect(parsed_response['access_token']).to_not be_nil
    expect(parsed_response['email']).to eq 'test@example.com'
    expect(parsed_response['first_name']).to eq 'Bob'
    expect(parsed_response['last_name']).to eq 'Test'
  end

  it 'allows a user to log out, deleting their session' do
    post '/login', email: 'test@example.com', password: 'secret'
    expect(last_response.status).to eq 200
    expect(Session.count).to eq 1

    access_token = JSON.parse(last_response.body)['access_token']

    header 'ACCESS_TOKEN', access_token
    delete '/logout'
    expect(last_response.status).to eq 204
    expect(Session.count).to eq 0
  end
end
