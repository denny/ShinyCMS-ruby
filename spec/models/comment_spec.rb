# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for comment model
RSpec.describe Comment, type: :model do
  describe 'concerns' do
    it_behaves_like ShinyDemoDataProvider do
      let( :model ) { described_class }
    end
  end
end
