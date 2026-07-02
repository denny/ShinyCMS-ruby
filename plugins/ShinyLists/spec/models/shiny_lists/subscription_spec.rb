# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for mailing list subscriptions model
RSpec.describe ShinyLists::Subscription, type: :model do
  describe 'scopes' do
    let( :list ) { create :mailing_list }

    describe '.active' do
      it 'does not include subscribers who have unsubscribed' do
        create :mailing_list_subscription, list: list
        create :mailing_list_subscription, list: list, unsubscribed_at: 1.day.ago

        expect( list.subscriptions.active.count ).to eq 1
      end
    end
  end

  describe 'instance methods' do
    describe '.unsubscribe' do
      it 'sets the unsubscribed timestamp' do
        sub1 = create :mailing_list_subscription
        expect( sub1.reload.unsubscribed_at ).to be_nil
        sub1.unsubscribe
        expect( sub1.reload.unsubscribed_at ).not_to be_nil
      end
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end
  end
end
