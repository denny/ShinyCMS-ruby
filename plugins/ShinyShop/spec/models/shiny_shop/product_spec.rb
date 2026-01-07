# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Product model tests
RSpec.describe ShinyShop::Product, type: :model do
  describe '.visible' do
    it 'only shows the product which is marked visible on in our db and on Stripe' do
      create :product, show_on_site: false, active: false
      create :product, show_on_site: false, active: true
      create :product, show_on_site: true,  active: false
      p4 = create :product, show_on_site: true,  active: true

      expect( described_class.visible ).to eq [ p4 ]
    end
  end
end
