require 'rails_helper'
include Warden::Test::Helpers

describe 'only admins can see the admin site' do
  before do
    Warden.test_mode!
    invitation = Invitation.create
    guest = Guest.create(invitation: invitation, email: 'guest@example.com', first_name: 'Admin', last_name: 'Jones')
    user = User.create(guest_id: guest.id,  is_admin: true)
    login_as(user)
  end

  after do
    Warden.test_reset!
  end

  xit 'shows an admin link when logged in as an admin' do
    visit '/'
    expect(page).to_not have_content 'Whitsonwedding Rails'

    expect(page).to have_content 'Admin'
    click_on 'Admin'

    expect(page).to have_content 'Whitsonwedding Rails'
  end
end
