# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Access Group membership model
RSpec.describe ShinyAccess::Membership, type: :model do
  describe 'scopes' do
    describe '.active' do
      it 'does not include memberships that have ended' do
        group = create :access_group
        create :access_membership, group: group
        create :access_membership, :ended, group: group

        expect( group.memberships.active.count ).to eq 1
      end
    end
  end

  describe 'instance methods' do
    describe '.end' do
      it 'sets the ended_at timestamp' do
        membership1 = create :access_membership
        expect( membership1.reload.ended_at ).to be_nil
        membership1.end
        expect( membership1.reload.ended_at ).not_to be_nil
      end
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end
  end
end
