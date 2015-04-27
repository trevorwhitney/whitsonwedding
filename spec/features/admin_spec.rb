require 'rails_helper'
include Warden::Test::Helpers

describe 'only admins can see the admin site', js: true do
  it 'shows an admin link when logged in as an admin' do
    login_admin

    visit '/'
    expect(page).to_not have_content 'Whitsonwedding Rails'

    expect(page).to have_content 'Admin'
    click_on 'Admin'

    expect(page).to have_content 'Whitsonwedding Rails'
  end

  it 'does not show an admin link when logged in as a user who is not an admin' do
    login_user

    visit '/'
    expect(page).to_not have_content 'Whitsonwedding Rails'

    expect(page).to_not have_content 'Admin'
  end
end
