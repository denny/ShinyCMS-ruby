# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for model holding details of unauthenticated comment authors
RSpec.describe ShinyCMS::PseudonymousAuthor, type: :model do
  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end

    it_behaves_like 'ShinyCMS::Comment.author' do
      let( :author ) { create :pseudonymous_author }
    end
  end
end
