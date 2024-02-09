# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

RSpec.describe ShinyNews::Post, type: :model do
  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end

    it_behaves_like ShinyCMS::Post do
      let( :post ) { create :news_post }
    end

    it_behaves_like 'Voteable' do
      let( :item ) { create :news_post }
    end
  end
end
