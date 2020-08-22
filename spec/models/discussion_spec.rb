# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for discussion model
RSpec.describe Discussion, type: :model do
  context 'factory' do
    it 'can create a discussion' do
      news_post  = create :news_post
      discussion = create :discussion, resource: news_post

      expect( Discussion.last ).to eq discussion
    end
  end

  context 'methods' do
    context '.recently_active' do
      before :each do
        @active_last_week = create :news_post
        @active_this_week = create :news_post
        @less_active_post = create :news_post
        @an_inactive_post = create :news_post

        create :discussion, resource: @active_last_week, comment_count: 5, comments_posted_at: 8.days.ago
        create :discussion, resource: @active_this_week, comment_count: 4
        create :discussion, resource: @less_active_post, comment_count: rand(1..3)
        create :discussion, resource: @an_inactive_post, comment_count: 0
      end

      describe 'without params' do
        it 'fetches the most active discussions from the last week, most active first' do
          active, counts = Discussion.recently_active

          expect( active.length ).to eq 2
          expect( active.find( counts.to_h.keys.first ).resource ).to eq @active_this_week
        end
      end

      describe 'with params' do
        it 'fetches the most active discussions from the specified timespan' do
          active, counts = Discussion.recently_active( days: 14 )

          expect( active.length ).to eq 3
          expect( active.find( counts.to_h.keys.first ).resource ).to eq @active_last_week
        end
      end

      describe 'when discussions have no comments' do
        it "doesn't include them" do
          active, _counts = Discussion.recently_active

          expect( active.length ).to eq 2
          # TODO: expect( active.resources ).not_to include @an_inactive_post
          expect( active.first.resource  ).not_to eq @an_inactive_post
          expect( active.second.resource ).not_to eq @an_inactive_post
        end
      end
    end
  end

  it_should_behave_like ShinyDemoDataProvider do
    let( :model ) { described_class }
  end
end
