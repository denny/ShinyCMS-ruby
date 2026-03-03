# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for VoteableIP model - anonymous up/down votes
RSpec.describe ShinyCMS::VotableIP, type: :model do
  describe 'concerns' do
    it_behaves_like 'VoteableVoter' do
      let( :voter ) { create :votable_ip }
    end
  end
end
