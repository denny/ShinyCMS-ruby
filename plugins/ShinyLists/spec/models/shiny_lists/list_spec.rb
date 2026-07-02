# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for mailing list model
RSpec.describe ShinyLists::List, type: :model do
  describe 'instance methods' do
    let( :list ) { create :mailing_list }
    let( :user ) { create :user         }

    describe '.subscribed?' do
      it 'returns true if the email address is subscribed' do
        create :mailing_list_subscription, list: list, subscriber: user

        expect( list.subscribed?( user.email ) ).to be true
      end

      it 'returns false if the email address is not subscribed' do
        expect( list.subscribed?( user.email ) ).to be false
      end
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end

    it_behaves_like ShinyCMS::HasSlug do
      let( :sluggish ) { create :mailing_list }
    end
  end
end
