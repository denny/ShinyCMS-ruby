# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Shared test code, for testing the methods mixed-in by acts_as_voteable
RSpec.shared_examples 'Voteable' do
  describe '.vote_up' do
    it 'adds a vote to the item' do
      voter = create :user

      expect( item.get_upvotes.size ).to eq 0
      item.vote_up voter
      expect( item.get_upvotes.size ).to eq 1
    end
  end
end
