# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Shared test code, for testing the methods mixed-in by acts_as_voteable
RSpec.shared_examples 'VoteableVoter' do
  describe '.up_votes' do
    it 'adds a vote to the item' do
      comment = create :comment

      expect( voter.voted_for?( comment ) ).to be false
      voter.up_votes comment
      expect( voter.voted_for?( comment ) ).to be true
    end
  end
end
