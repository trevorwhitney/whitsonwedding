def create_invitation(options={})
  Invitation.create!
end

def create_guest(options={})
  invitation = options.delete(:invitation) || create_invitation
  defaults = {
    first_name: 'joe',
    last_name: 'test',
    invitation_id: invitation.id
  }
  Guest.create!(defaults.merge(options))
end


def create_user(options={})
  guest = options.delete(:guest) || create_guest
  password = options.delete(:password) || 'secret'
  password_confirmation = options.delete(:password_confirmation) || password
  defaults = {
    email: "tester#{SecureRandom.uuid}@example.com",
    password: password,
    password_confirmation: password_confirmation,
    guest_id: guest.id,
    is_admin: options[:is_admin] || false
  }
  User.create!(defaults.merge(options))
end

def create_admin(options = {})
  create_user(options.merge(is_admin: true))
end

def login(user_email, password)
  visit '/'
  expect(page).to have_content 'Log In'
  find('a', text: 'Log In').click

  fill_in :email, with: user_email
  fill_in :password, with: password

  click_on 'Sign In'

  wait_for_ajax
  wait_for_animations

  expect(page).to have_content 'Log Out'
end

def login_user(password = 'secret', user = nil)
  user = user || create_user(password: password, password_confirmation: password)
  login(user.email, password)
end

def logout_user
  find('a', text: 'Log Out').click
  wait_for_ajax
end

def login_admin
  admin = create_admin(password: 'secret')
  login(admin.email, 'secret')
end
