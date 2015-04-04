RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

def login_admin
  invitation = Invitation.create!
  guest = Guest.create!(first_name: 'joe', last_name: 'test', invitation_id: invitation.id)
  User.create!(email: 'tester@example.com',
               password: 'secret',
               password_confirmation: 'secret',
               guest_id: guest.id,
               is_admin: true)
  visit '/'
  expect(page).to have_content 'Log In'
  find('a', text: 'Log In').click

  fill_in :email, with: 'tester@example.com'
  fill_in :password, with: 'secret'

  click_on 'Sign In'

  wait_for_ajax

  expect(page).to have_content 'Log Out'
end
