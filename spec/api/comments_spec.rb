require 'rails_helper'

describe 'leaving comments' do
  before do
    invitation = Invitation.create
    @john_guest = Guest.create(
      first_name: 'John',
      last_name: 'Smith',
      invitation: invitation
    )
    @john_user = User.create(
      guest: @john_guest,
      email: 'john@example.com',
      password: 'secret',
      password_confirmation: 'secret'
    )

  end

  context 'when the user is signed in' do
    before do
      post '/login', email: 'john@example.com', password: 'secret'
      expect(response).to have_http_status(:ok)
      @access_token = JSON.parse(response.body)['access_token']
    end

    it 'allows them to leave a comment' do
      post '/comments', body: 'Hello world', access_token: @access_token
      expect(response).to have_http_status(:created)

      comments = @john_user.reload.comments
      expect(comments.size).to eq 1
      expect(comments.first.body).to eq 'Hello world'
    end

    it 'allows them to leave multiple comments' do
      post '/comments', body: 'Hello world', access_token: @access_token
      expect(response).to have_http_status(:created)

      post '/comments', body: 'Hello world', access_token: @access_token
      expect(response).to have_http_status(:created)

      comments = @john_user.reload.comments
      expect(comments.size).to eq 2
    end
  end

  context 'when the user is not logged in' do
    it 'does not allow them to create comments' do
      headers 'Content-Type' => 'application/json', 'Accept' => 'appliction/json'
      post '/comments', body: 'Hello world'
      expect(response.status).to eq 404
      expect(@john_user.reload.comments).to be_empty
    end
  end
end
