# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for newsletter edition element model
RSpec.describe ShinyNewsletters::EditionElement, type: :model do
  it_behaves_like ShinyCMS::Element do
    let( :edition ) { create :newsletter_edition                           }
    let( :element ) { create :newsletter_edition_element, edition: edition }
  end

  it_behaves_like ShinyCMS::ProvidesDemoSiteData do
    let( :model ) { described_class }
  end
end
