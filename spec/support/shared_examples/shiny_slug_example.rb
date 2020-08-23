# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Shared test code, for testing methods mixed-in by the ShinySlug concern
RSpec.shared_examples ShinySlug do
  context 'generation' do
    it 'can create a slug' do
      sluggish.slug = nil
      expect( sluggish.slug ).to be_blank

      sluggish.generate_slug
      expect( sluggish.slug ).to match %r{[-\w]+}
    end
  end
end
