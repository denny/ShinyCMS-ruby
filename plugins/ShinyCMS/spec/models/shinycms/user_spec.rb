# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for user model
RSpec.describe ShinyCMS::User, type: :model do
  describe 'concerns' do
    it_behaves_like ShinyCMS::HasEmail do
      let( :addressee ) { create :user }
    end

    it_behaves_like 'ShinyCMS::Comment.author' do
      let( :author ) { create :user }
    end

    it_behaves_like 'VoteableVoter' do
      let( :voter ) { create :user }
    end
  end
end
