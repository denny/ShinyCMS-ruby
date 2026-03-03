# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Shared test code, for testing methods mixed-in by the ShinySlug concern
RSpec.shared_examples ShinyCMS::HasSlug do
  describe 'slug generation' do
    it 'can generate a slug' do
      sluggish.slug = nil
      expect( sluggish.slug ).to be_blank

      sluggish.generate_slug
      if sluggish.respond_to? :title
        expect( sluggish.slug ).to eq sluggish.title.parameterize
      else
        expect( sluggish.slug ).to eq sluggish.name.parameterize
      end
    end
  end
end
