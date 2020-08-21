# frozen_string_literal: true

# ============================================================================
# Project:   ShinyInserts plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyInserts/spec/models/shiny_inserts/element.rb
# Purpose:   Tests for ShinyInsert::Element model
#
# Copyright 2009-2020 Denny de la Haye (https://denny.me)
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

require 'rails_helper'

module ShinyInserts
  RSpec.describe Element, type: :model do
    it_should_behave_like ShinyElement do
      let( :element ) { create :insert_element }
    end

    it_should_behave_like ShinyDemoDataProvider do
      let( :model ) { described_class }
    end
  end
end
