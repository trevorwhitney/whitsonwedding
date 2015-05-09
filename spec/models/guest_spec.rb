require 'rails_helper'

describe Guest do
  let(:invitation) { Invitation.create! }
  describe '.find_by_email' do
    it 'is case insensitive when searching by email' do
      bob = Guest.create!(first_name: 'Bob',
                          last_name: 'Smith',
                          email: 'BSmith@example.com',
                          invitation: invitation)

      expect(Guest.find_by_email('bsmith@example.com')).to eq bob

      ben = Guest.create!(first_name: 'Ben',
                          last_name: 'Jones',
                          email: 'bjones@example.com',
                          invitation: invitation)
      expect(Guest.find_by_email('BJones@example.com')).to eq ben
    end

    it 'strips whitespace on email' do
      bob = Guest.create!(first_name: 'Bob',
                          last_name: 'Smith',
                          email: ' bsmith@example.com ',
                          invitation: invitation)
      expect(Guest.find_by_email('bsmith@example.com')).to eq bob

      ben = Guest.create!(first_name: 'Ben',
                          last_name: 'Jones',
                          email: 'bjones@example.com',
                          invitation: invitation)
      expect(Guest.find_by_email(' BJones@example.com ')).to eq ben
    end
  end
end
