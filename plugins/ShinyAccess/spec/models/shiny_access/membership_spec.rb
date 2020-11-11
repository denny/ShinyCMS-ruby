# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for Access Group membership model
module ShinyAccess
  RSpec.describe Membership, type: :model do
    context 'scopes' do
      describe '.active' do
        it 'does not include memberships that have ended' do
          group = create :access_group
          create :access_membership, group: group
          create :access_membership, :ended, group: group

          expect( group.memberships.active.count ).to eq 1
        end
      end
    end

    context 'instance methods' do
      describe '.end' do
        it 'sets the ended_at timestamp' do
          membership1 = create :access_membership
          expect( membership1.reload.ended_at ).to be nil
          membership1.end
          expect( membership1.reload.ended_at ).not_to be nil
        end
      end
    end

    context 'concerns' do
      it_should_behave_like ShinyDemoDataProvider do
        let( :model ) { described_class }
      end
    end
  end
end
