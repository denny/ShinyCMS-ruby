# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for user profile model
module ShinyProfiles
  RSpec.describe Profile, type: :model do
    describe 'Instance methods' do
      describe '.name' do
        it 'returns the public_name if one is set' do
          user = create :user
          user.profile.update!( public_name: 'Testy McTestface' )

          expect( user.profile.name ).to eq user.profile.public_name
        end

        it "returns the user's username if no public_name is set" do
          user = create :user
          user.profile.update!( public_name: nil )

          expect( user.profile.name ).to eq user.username
        end
      end
    end
  end
end
