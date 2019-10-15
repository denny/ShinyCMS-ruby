require 'rails_helper'

RSpec.describe User, type: :model do
  context 'factory' do
    it 'can create a user' do
      user = create :user
      expect( user.username ).to match( /\w+/ )
    end
  end
end
