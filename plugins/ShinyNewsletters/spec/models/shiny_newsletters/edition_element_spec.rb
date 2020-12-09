# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for newsletter edition element model
module ShinyNewsletters
  RSpec.describe EditionElement, type: :model do
    it_should_behave_like ShinyElement do
      let( :edition ) { create :newsletter_edition                           }
      let( :element ) { create :newsletter_edition_element, edition: edition }
    end

    it_should_behave_like ShinyDemoDataProvider do
      let( :model ) { described_class }
    end
  end
end
