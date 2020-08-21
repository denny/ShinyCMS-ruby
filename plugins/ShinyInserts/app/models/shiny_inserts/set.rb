# frozen_string_literal: true

# ============================================================================
# Project:   ShinyInserts plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyInserts/app/models/shiny_inserts/set.rb
# Purpose:   Model for insert sets (used as a handle to update all elements)
#
# Copyright 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyInserts
  # Model class for Insert Sets - from the ShinyInserts plugin for ShinyCMS
  class Set < ApplicationRecord
    has_many :elements, -> { order( :name ) },  inverse_of: :set,
                                                foreign_key: :set_id,
                                                class_name: 'ShinyInserts::Element',
                                                dependent: :destroy

    accepts_nested_attributes_for :elements

    # Specify policy class for Pundit
    def policy_class
      ShinyInserts::SetPolicy
    end
  end
end
