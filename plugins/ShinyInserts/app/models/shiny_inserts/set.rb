# frozen_string_literal: true

# ShinyInserts plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyInserts
  # Model class for Insert Sets - from the ShinyInserts plugin for ShinyCMS
  class Set < ApplicationRecord
    include ShinyCMS::SoftDelete

    has_many :elements, -> { order( :name ) }, inverse_of: :set, dependent: :destroy,
                                               class_name: 'ShinyInserts::Element'

    accepts_nested_attributes_for :elements
  end
end
