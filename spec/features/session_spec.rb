require 'rails_helper'

describe 'logging in and out' do
  before do
    User.delete_all
    Session.delete_all

    User.create!(email: 'test@example.com', password: 'secret')
  end

  it 'allows a user to login' do
    post '/api/login', email: 'test@example.com', password: 'secret'
    expect(last_response.status).to eq 200
    parsed_response = JSON.parse(last_response.body)
    expect(parsed_response['access_token']).to_not be_nil
    expect(parsed_response['email']).to eq 'test@example.com'
  end

  it 'allows a user to log out, deleting their session' do
    post '/api/login', email: 'test@example.com', password: 'secret'
    expect(last_response.status).to eq 200
    expect(Session.count).to eq 1

    access_token = JSON.parse(last_response.body)['access_token']

    header 'ACCESS_TOKEN', access_token
    delete '/api/logout', access_token: access_token
    expect(last_response.status).to eq 204
    expect(Session.count).to eq 0
  end
end
