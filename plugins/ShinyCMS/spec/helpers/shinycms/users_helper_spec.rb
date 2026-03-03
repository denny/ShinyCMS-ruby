# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for plugin helper methods
RSpec.describe ShinyCMS::UsersHelper, type: :helper do
  describe 'users_that_can_for_menu' do
    it 'returns username and ID of users with the specified capability, sorted by username' do
      create :blog_admin, username: 'zebedee'
      create :blog_admin, username: 'adam'
      create :news_admin, username: 'newsagent'

      results = helper.users_that_can_for_menu( :list, :blog_posts )

      expect( results ).to be_an Array
      expect( results ).to all be_an Array

      expect( results.size ).to eq 2

      expect( results.first.first ).to eq 'adam'
      expect( results.last.first  ).to eq 'zebedee'

      expect( results.first.second > results.last.second ).to be true
    end
  end
end
