# frozen_string_literal: true

# ShinyInserts plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for insert elements
module ShinyInserts
  RSpec.describe Element, type: :model do
    describe 'concerns' do
      it_behaves_like ShinyCMS::Element do
        let( :element ) { create :insert_element }
      end

      it_behaves_like ShinyCMS::ProvidesDemoSiteData do
        let( :model ) { described_class }
      end
    end
  end
end
