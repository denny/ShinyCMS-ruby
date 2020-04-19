# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DoNotContact, type: :model do
  context 'when adding a new email address to the DoNotContact list' do
    it 'it is stored in canonicalised and redacted form' do
      nope = create :do_not_contact, email: 'ShinyCMS+tests@example.com'

      expect( nope.email ).not_to eq 'ShinyCMS+tests@example.com'
      expect( nope.email ).not_to eq 'shinycms@example.com'
      expect( nope.email ).to     eq '{c33ca35ec7c29c231cc1d2d8c0639e91ddb79b48}@example.com'
    end

    it "it is stored 'as is' if it's already redacted" do
      nope = create :do_not_contact, email: '{c33ca35ec7c29c231cc1d2d8c0639e91ddb79b48}@example.com'

      expect( nope.email ).to eq '{c33ca35ec7c29c231cc1d2d8c0639e91ddb79b48}@example.com'
    end
  end

  context 'when checking whether the DoNotContact list .includes? a given email' do
    it 'a match is found when using a non-redacted, non-canonical address as input' do
      nope = create :do_not_contact, email: 'ShinyCMS+tests@example.com'

      expect( nope.email ).to eq '{c33ca35ec7c29c231cc1d2d8c0639e91ddb79b48}@example.com'

      expect( DoNotContact.includes?( 'ShinyCMS+TEST@example.com' ) ).to be true
    end
  end
end
