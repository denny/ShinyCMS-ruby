# frozen_string_literal: true

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
