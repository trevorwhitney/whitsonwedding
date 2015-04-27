require 'rails_helper'

describe User do
  describe '#can_rsvp_for?' do
    it 'returns false if the user is not on the same invitation as the guest' do
      guest = Guest.new
      user = User.new
      expect(user.can_rsvp_for?(guest)).to eq false
    end

    it 'returns true if the user is on the same invitation as the guest' do
      users_invitation = Invitation.create
      other_invitation = Invitation.create
      guest = Guest.create(invitation: users_invitation)
      other_guest = Guest.create(invitation: other_invitation)
      users_guest = Guest.create(invitation: users_invitation)
      user = User.create(guest: users_guest)
      expect(user.can_rsvp_for?(guest)).to eq true
      expect(user.can_rsvp_for?(other_guest)).to eq false
    end
  end
end
