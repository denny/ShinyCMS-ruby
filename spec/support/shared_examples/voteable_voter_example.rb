# frozen_string_literal: true

# Shared test code, for testing the methods mixed-in by acts_as_voteable
RSpec.shared_examples 'VoteableVoter' do
  context '.up_votes' do
    it 'adds a vote to the item' do
      news_post  = create :shiny_news_post
      discussion = create :discussion, resource: news_post
      comment    = create :comment, discussion: discussion

      expect( voter.voted_for?( comment ) ).to be false
      voter.up_votes comment
      expect( voter.voted_for?( comment ) ).to be true
    end
  end
end
