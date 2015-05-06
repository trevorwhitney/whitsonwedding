require 'rails_helper'

describe 'comments', js: true do
  before do
    invitation = create_invitation
    joe = create_guest(invitation: invitation, first_name: 'Joe', last_name: 'Test')
    user = create_user(guest: joe, password: 'secret')

    login_user('secret', user)
  end

  it 'allows a user to submit a comment' do
    within '#user' do
      expect(page).to have_content 'RSVP'
      page.find('a', text: 'RSVP').click
    end

    wait_for_ajax

    within('#comment-form') do
      fill_in 'comment', with: 'hello world'
      click_on 'Submit'
    end
  end
end
