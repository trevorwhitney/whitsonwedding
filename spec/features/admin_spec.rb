require 'rails_helper'
include Warden::Test::Helpers

describe 'only admins can see the admin site', js: true do
  before do
    login_admin
  end

  it 'shows an admin link when logged in as an admin' do
    visit '/'
    expect(page).to_not have_content 'Whitsonwedding Rails'

    expect(page).to have_content 'Admin'
    click_on 'Admin'

    expect(page).to have_content 'Whitsonwedding Rails'
  end
end
