# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for some of the methods in the main site helper module
RSpec.describe ShinyLists::MainSiteHelper, type: :helper do
  describe 'find_list_by_slug( slug )' do
    it 'returns the mailing_list matching the slug' do
      list1 = create :mailing_list, slug: 'newsletter'

      expect( helper.find_list_by_slug( 'newsletter' ) ).to eq list1
    end
  end

  describe 'most_recent_list' do
    it 'returns the last list created' do
      create :mailing_list
      sleep 1
      list2 = create :mailing_list

      expect( helper.most_recent_list ).to eq list2
    end
  end
end
