require 'rails_helper'

describe 'rsvps', js: true do
  it 'allows a guest to rsvp for anyone on their invitation' do
    invitation = create_invitation
    other_invitation = create_invitation
    joe = create_guest(invitation: invitation, first_name: 'Joe', last_name: 'Test')
    sally = create_guest(invitation: invitation, first_name: 'Sally', last_name: 'Test')
    create_guest(invitation: other_invitation, first_name: 'Other', last_name: 'Guest')
    user = create_user(guest: joe, password: 'secret')
    sally_user = create_user(guest: sally, password: 'secret')

    login_user('secret', user)

    within '#user' do
      expect(page).to have_content 'RSVP'
      page.find('a', text: 'RSVP').click
    end

    wait_for_animations

    within('div.guest', text: 'Joe Test') do
      expect(page).to have_content 'Joe Test'
      expect(page).to have_css '.rsvp-no.active'
      find('label.rsvp-yes').click
    end

    within('div.guest', text: 'Sally Test') do
      expect(page).to have_content 'Sally Test'
      expect(page).to have_css '.rsvp-no.active'
      find('label.rsvp-yes').click
    end

    expect(page).to_not have_content 'Other Guest'

    wait_for_ajax
    click_on 'Close'

    logout_user
    visit '/'
    login_user('secret', sally_user)

    within '#user' do
      page.find('a', text: 'RSVP').click
      wait_for_animations
    end

    within('div.guest', text: 'Joe Test') do
      expect(page).to have_content 'Joe Test'
      expect(page).to have_css '.rsvp-yes.active'
    end

    within('div.guest', text: 'Sally Test') do
      expect(page).to have_content 'Sally Test'
      expect(page).to have_css '.rsvp-yes.active'
      find('label.rsvp-no').click
    end

    expect(page).to_not have_content 'Other Guest'

    wait_for_ajax

    visit '/'
    within '#user' do
      page.find('a', text: 'RSVP').click
      wait_for_animations
    end

    within('div.guest', text: 'Sally Test') do
      expect(page).to have_content 'Sally Test'
      expect(page).to have_css '.rsvp-no.active'
    end

    within('div.guest', text: 'Joe Test') do
      expect(page).to have_content 'Joe Test'
      expect(page).to have_css '.rsvp-yes.active'
    end
  end
end
