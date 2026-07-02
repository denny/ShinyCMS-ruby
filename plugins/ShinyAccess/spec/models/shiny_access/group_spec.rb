# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Access Group model
RSpec.describe ShinyAccess::Group, type: :model do
  describe 'instance methods' do
    let( :test_group ) { create :access_group }
    let( :test_user  ) { create :user         }

    describe '.member?' do
      it 'returns true if the user is a member of the group' do
        create :access_membership, group: test_group, user: test_user

        expect( test_group.member?( test_user ) ).to be true
      end

      it 'returns false if the user is not a member of the group' do
        expect( test_group.member?( test_user ) ).to be false
      end
    end

    describe '.add_member( user )' do
      it 'returns true if the user is added to the group' do
        expect( test_group.add_member( test_user ) ).to be true
      end

      it 'returns false if the user is already a member of the group' do
        create :access_membership, group: test_group, user: test_user

        expect( test_group.add_member( test_user ) ).to be false
      end
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end

    it_behaves_like ShinyCMS::HasSlug do
      let( :sluggish ) { create :access_group }
    end
  end
end
