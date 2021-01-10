# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for discussion model
RSpec.describe Discussion, type: :model do
  describe '.recently_active' do
    before do
      @active_last_week = create :news_post
      @active_this_week = create :news_post
      @less_active_post = create :news_post
      @an_inactive_post = create :news_post

      create :discussion, resource: @active_last_week, comment_count: 5, comments_posted_at: 8.days.ago
      create :discussion, resource: @active_this_week, comment_count: 4
      create :discussion, resource: @less_active_post, comment_count: rand( 1..3 )
      create :discussion, resource: @an_inactive_post, comment_count: 0
    end

    context 'without params' do
      it 'fetches the most active discussions from the last week, most active first' do
        active, counts = described_class.recently_active

        expect( active.length ).to eq 2
        expect( active.find( counts.to_h.keys.first ).resource ).to eq @active_this_week
      end
    end

    context 'with params' do
      it 'fetches the most active discussions from the specified timespan' do
        active, counts = described_class.recently_active( days: 14 )

        expect( active.length ).to eq 3
        expect( active.find( counts.to_h.keys.first ).resource ).to eq @active_last_week
      end
    end

    context 'when discussions have no comments' do
      it "doesn't include them" do
        active, _counts = described_class.recently_active

        expect( active.length ).to eq 2
        # TODO: expect( active.resources ).not_to include @an_inactive_post
        expect( active.first.resource  ).not_to eq @an_inactive_post
        expect( active.second.resource ).not_to eq @an_inactive_post
      end
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyDemoDataProvider do
      let( :model ) { described_class }
    end
  end
end
