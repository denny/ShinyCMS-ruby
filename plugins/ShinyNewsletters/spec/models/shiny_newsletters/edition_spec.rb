# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for newsletter edition model
RSpec.describe ShinyNewsletters::Edition, type: :model do
  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end
  end
end
