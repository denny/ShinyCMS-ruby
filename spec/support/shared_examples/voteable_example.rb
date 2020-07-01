# frozen_string_literal: true

# Shared test code, for testing the methods mixed-in by acts_as_voteable
RSpec.shared_examples 'Voteable' do
  context '.vote_up' do
    it 'adds a vote to the item' do
      voter = create :user
      expect( item.get_upvotes.size ).to eq 0
      item.vote_up voter
      expect( item.get_upvotes.size ).to eq 1
    end
  end
end
