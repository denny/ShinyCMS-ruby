# frozen_string_literal: true

# ============================================================================
# Project:   ShinyPages plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyPages/spec/factories/pages.rb
# Purpose:   Factory for ShinyPages::Page
#
# Copyright 2009-2020 Denny de la Haye (https://denny.me)
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

FactoryBot.define do
  factory :page, class: 'ShinyPages::Page', aliases: [ :top_level_page ] do
    internal_name { Faker::Books::CultureSeries.unique.culture_ship }
    slug   { internal_name.dup.parameterize }
    association :template, factory: :page_template

    trait :hidden do
      show_on_site { false }
    end
  end

  factory :page_in_section, parent: :page do
    association :section, factory: :page_section
  end

  factory :page_in_subsection, parent: :page do
    association :section, factory: :page_subsection
  end

  factory :page_with_one_of_each_element_type, parent: :page do
    after :create do |page|
      create :short_text_page_element, page: page, name: 'short_text',   content: 'SHORT!'
      create :long_text_page_element,  page: page, name: 'long_text',    content: 'LONG!'
      create :image_page_element,      page: page, name: 'image_select', content: 'IMAGE.png'
      create :html_page_element,       page: page, name: 'html',         content: 'HTML!'
    end
  end
end
