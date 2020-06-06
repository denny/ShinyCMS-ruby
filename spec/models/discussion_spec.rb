# frozen_string_literal: true

require 'rails_helper'

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
      before :all do
        @less_active_post = create :news_post
        @active_this_week = create :news_post
        @active_last_week = create :news_post

        create :discussion_with_four_comments, resource: @less_active_post
        create :discussion_with_five_comments, resource: @active_this_week
        create :discussion_with_6old_comments, resource: @active_last_week
      end

      describe 'without params' do
        it 'fetches the most active discussions from the last week, most active first' do
          active, counts = Discussion.recently_active

          expect( active.length ).to eq 2
          expect( active.find( counts.first.first ).resource ).to eq @active_this_week
        end
      end

      describe 'with params' do
        it 'fetches the most active discussions from the specified timespan' do
          active, counts = Discussion.recently_active( days: 14 )

          expect( active.length ).to eq 3
          expect( active.find( counts.first.first ).resource ).to eq @active_last_week
        end
      end
    end
  end
end
