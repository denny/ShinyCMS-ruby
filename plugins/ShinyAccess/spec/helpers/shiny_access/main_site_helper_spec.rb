# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for some of the methods in the main site helper module
RSpec.describe ShinyAccess::MainSiteHelper, type: :helper do
  let( :user1 ) do
    user1 = create :user
    sign_in user1
    user1
  end

  describe 'current_user_can_access?( :slug )' do
    it 'returns true if they do have active membership of the specified group' do
      group1 = create :access_group, slug: 'TestSuite'
      group1.add_member( user1 )

      expect( helper.current_user_can_access?( :TestSuite ) ).to be true
    end

    it 'returns false if they do not have membership of the specified group' do
      create :access_group, slug: 'AnotherTest'

      expect( helper.current_user_can_access?( :AnotherTest ) ).to be false
    end

    it 'returns false if the group does not exist' do
      expect( helper.current_user_can_access?( :NoSuchGroup ) ).to be false
    end

    it 'returns false if their membership of the specified group has ended' do
      group1 = create :access_group, slug: 'MoarTest'
      create :access_membership, :ended, user: user1, group: group1

      expect( helper.current_user_can_access?( :MoarTest ) ).to be false
    end
  end

  describe 'access_group_name( :slug )' do
    it 'returns the name of the access group if it exists' do
      group1 = create :access_group, slug: 'TestSuite'

      expect( helper.access_group_name( :TestSuite ) ).to eq group1.name
    end

    it 'returns nil if the group does not exist' do
      expect( helper.access_group_name( :NoSuchGroup ) ).to be_nil
    end
  end
end
