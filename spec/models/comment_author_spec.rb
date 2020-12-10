# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for model holding details of unauthenticated comment authors
RSpec.describe CommentAuthor, type: :model do
  context 'factory' do
    describe 'create' do
      it 'generates a comment author instance' do
        author = create :comment_author

        expect( author ).to be_a described_class
      end
    end
  end
end
