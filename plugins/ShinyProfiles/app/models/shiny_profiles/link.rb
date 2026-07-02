# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Model for user profile pages
  class Link < ApplicationRecord
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    belongs_to :profile, inverse_of: :links

    acts_as_list scope: :profile

    if ShinyCMS.plugins.loaded? :ShinySearch
      include ShinySearch::Searchable

      searchable_by :name, :url  # TODO
    end

    validates :profile, presence: true
    validates :name,    presence: true
    validates :url,     presence: true

    delegate :hidden?, to: :profile

    def self.my_demo_data_position
      2  # after profiles
    end
  end
end
