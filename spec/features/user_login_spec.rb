require 'rails_helper'

tables = %w(
  users
  guests
  invitations
  sessions
)

describe 'user login and logout', js: true, tables: tables do
  before do
    invitation = Invitation.create!
    guest = Guest.create!(first_name: 'joe', last_name: 'test', invitation_id: invitation.id)
    User.create!(email: 'tester@example.com',
                password: 'secret',
                password_confirmation: 'secret',
                guest_id: guest.id)
  end

  it 'allows a user to login' do
   visit '/'
   expect(page).to have_content 'Log In'
   find('a', text: 'Log In').click

   fill_in :email, with: 'tester@example.com'
   fill_in :password, with: 'secret'

   click_on 'Sign In'

   wait_for_ajax

   expect(page).to have_content 'Log Out'
   find('a', text: 'Log Out').click

   wait_for_ajax

   expect(page).to have_content 'Log In'
  end
end
