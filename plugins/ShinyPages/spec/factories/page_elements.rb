# frozen_string_literal: true

# ============================================================================
# Project:   ShinyPages plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyPages/spec/factories/page_elements.rb
# Purpose:   Factory for ShinyPages::PageElement
#
# Copyright 2009-2020 Denny de la Haye (https://denny.me)
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

FactoryBot.define do
  factory :page_element, class: 'ShinyPages::PageElement' do
    name { Faker::Books::CultureSeries.unique.civs.parameterize }
  end

  factory :short_text_page_element, parent: :page_element do
    element_type { I18n.t( 'admin.elements.short_text' ) }
  end

  factory :long_text_page_element, parent: :page_element do
    element_type { I18n.t( 'admin.elements.long_text' ) }
  end

  factory :image_page_element, parent: :page_element do
    element_type { I18n.t( 'admin.elements.image' ) }
  end

  factory :html_page_element, parent: :page_element do
    element_type { I18n.t( 'admin.elements.html' ) }
  end
end
