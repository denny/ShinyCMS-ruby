# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Model for user profile pages (and related features)
  class Link < ApplicationRecord
    include ShinySearch::Searchable if ShinyPlugin.loaded? :ShinySearch
    include ShinyDemoDataProvider
    include ShinySoftDelete

    # Associations

    belongs_to :profile, inverse_of: :links

    # Plugin features

    acts_as_list scope: :profile

    searchable_by :name, :url if ShinyPlugin.loaded? :ShinySearch # TODO

    # Validations

    validates :profile, presence: true
    validates :name,    presence: true
    validates :url,     presence: true
  end
end
