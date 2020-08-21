# frozen_string_literal: true

# ============================================================================
# Project:   ShinyInserts plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyInserts/spec/factories/insert_element.rb
# Purpose:   Factory for ShinyInsert::Element
#
# Copyright 2009-2020 Denny de la Haye (https://denny.me)
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

FactoryBot.define do
  factory :insert_element, class: 'ShinyInserts::Element' do
    name { Faker::Books::CultureSeries.unique.civs.parameterize }
    element_type { I18n.t( 'admin.elements.short_text' ) }
    set { ShinyInserts::Set.first }
  end
end
