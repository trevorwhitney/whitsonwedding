require 'rails_helper'

describe 'creating a user' do
  let(:invitation) { Invitation.create! }
  before do
    @guest = Guest.create!(first_name: 'Bob', last_name: 'Jones', email: 'bjones@example.com', invitation: invitation)
  end

  it 'only allows a user to create an account if their email matches that of a guest' do
    post '/sign_up', email: 'phil@example.com', password: 'secret', password_confirmation: 'secret'
    expect(response.status).to eq 400
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['email']).to eq 'phil@example.com'
    expect(parsed_response['errors']['email']).
      to match_array(['does not match any emails we have on our guest list. ' +
                      "Maybe we have a different email for you? If you've tried them all, please let Trevor " +
                      'know at trevorjwhitney@gmail.com.'
    ])

    post '/sign_up', email: 'bjones@example.com', password: 'secret', password_confirmation: 'secret'
    expect(response.status).to eq 200

    user = User.last
    expect(user.email).to eq 'bjones@example.com'
    expect(user.first_name).to eq 'Bob'
    expect(user.last_name).to eq 'Jones'
    expect(user.guest.id).to eq @guest.id
  end

  it 'is case insensitive when matching guest emails' do
    post '/sign_up', email: 'BJones@example.com', password: 'secret', password_confirmation: 'secret'
    expect(response.status).to eq 200

    user = User.last
    expect(user.first_name).to eq 'Bob'
    expect(user.last_name).to eq 'Jones'
    expect(user.guest.id).to eq @guest.id

    bob = Guest.create!(first_name: 'Bob', last_name: 'Smith', email: 'BSmith@example.com', invitation: invitation)
    post '/sign_up', email: 'bsmith@example.com', password: 'secret', password_confirmation: 'secret'
    expect(response.status).to eq 200

    user = User.last
    expect(user.first_name).to eq 'Bob'
    expect(user.last_name).to eq 'Smith'
    expect(user.guest.id).to eq bob.id
  end

  it 'requires an email, password, and password_confirmation to create a user' do
    post '/sign_up', email: 'bjones@example.com'
    expect(response).to have_http_status(:bad_request)
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['errors']['password']).to include "can't be blank"
    expect(parsed_response['errors']['password_confirmation']).to include "can't be blank"
  end

  it 'validates that password and password confirmation match' do
    post '/sign_up', email: 'bjones@example.com', password: 'secret', password_confirmation: 'unknown'
    expect(response).to have_http_status(:bad_request)
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['errors']['password_confirmation']).to include "doesn't match Password"
  end

  it 'validates that the email is unique, and does not belong to an already created user' do
    post '/sign_up', email: 'bjones@example.com', password: 'secret', password_confirmation: 'secret'
    expect(response).to have_http_status(:ok)

    post '/sign_up', email: 'bjones@example.com', password: 'secret', password_confirmation: 'secret'
    expect(response).to have_http_status(:bad_request)

    parsed_response = JSON.parse(response.body)
    expect(parsed_response['errors']['email']).to include 'has already been taken'
  end

  it 'signs the user in, returning an authorization key, on accout creation' do
    post '/sign_up', email: 'bjones@example.com', password: 'secret', password_confirmation: 'secret'
    expect(response.status).to eq 200

    session = Session.last
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['access_token']).to eq session.access_token
  end
end
