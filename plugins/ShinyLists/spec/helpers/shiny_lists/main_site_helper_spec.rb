# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for some of the methods in the main site helper module
module ShinyLists
  RSpec.describe MainSiteHelper, type: :helper do
    describe 'find_list_by_slug( slug )' do
      it 'returns the mailing_list matching the slug' do
        list1 = create :mailing_list, slug: 'newsletter'

        expect( helper.find_list_by_slug( 'newsletter' ) ).to eq list1
      end
    end
  end
end
