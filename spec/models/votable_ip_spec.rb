# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for VoteableIP model - anonymous up/down votes
RSpec.describe VotableIP, type: :model do
  context 'concerns' do
    it_should_behave_like 'VoteableVoter' do
      let( :voter ) { create :votable_ip }
    end
  end
end
