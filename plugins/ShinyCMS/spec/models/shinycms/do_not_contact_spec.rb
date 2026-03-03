# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for 'do not contact' model - stores one-way encypted email addresses
RSpec.describe ShinyCMS::DoNotContact, type: :model do
  describe 'a new email address added to the DoNotContact list' do
    it 'is stored in canonicalised and redacted form' do
      nope = create :do_not_contact, email: 'ShinyCMS+tests@example.com'

      expect( nope.email ).not_to eq 'ShinyCMS+tests@example.com'
      expect( nope.email ).not_to eq 'shinycms@example.com'
      expect( nope.email ).to     eq '{c33ca35ec7c29c231cc1d2d8c0639e91ddb79b48}@example.com'
    end

    it "is stored 'as is' if it's already redacted" do
      nope = create :do_not_contact, email: '{c33ca35ec7c29c231cc1d2d8c0639e91ddb79b48}@example.com'

      expect( nope.email ).to eq '{c33ca35ec7c29c231cc1d2d8c0639e91ddb79b48}@example.com'
    end
  end

  describe 'checking whether the DoNotContact list includes a given email' do
    it 'matches when using a non-redacted, non-canonical address as input' do
      nope = create :do_not_contact, email: 'ShinyCMS+tests@example.com'

      expect( nope.email ).to eq '{c33ca35ec7c29c231cc1d2d8c0639e91ddb79b48}@example.com'

      expect( described_class.listed?( 'ShinyCMS+TEST@example.com' ) ).to be true
    end

    it 'does not match an address which has not set as DNC' do
      expect( described_class.not_listed?( 'YourIdeasAreIntriguingToMe@example.com' ) ).to be true
    end
  end
end
