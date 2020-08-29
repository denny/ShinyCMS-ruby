# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Model for an edition of a newsletter
  class Edition < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyName
    include ShinyShowHide
    include ShinySlug
    include ShinyWithTemplate

    # Associations

    belongs_to :template, inverse_of: :editions
    has_many   :sends,    inverse_of: :edition
    has_many   :elements, -> { order( :id ) },  inverse_of: :edition,
                                                foreign_key: :edition_id,
                                                class_name: 'EditionElement',
                                                dependent: :destroy

    accepts_nested_attributes_for :elements

    # Class methods

    def self.policy_class
      EditionPolicy
    end
  end
end
