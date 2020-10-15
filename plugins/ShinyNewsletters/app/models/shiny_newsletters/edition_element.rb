# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Model for newsletter edition elements
  class EditionElement < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyElement

    # Associations

    belongs_to :edition, inverse_of: :elements

    # Plugin features

    acts_as_list scope: :edition

    # Validations

    validates :edition, presence: true
  end
end
