# frozen_string_literal: true

# ============================================================================
# Project:   ShinyPages plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyPages/spec/factories/page_templates.rb
# Purpose:   Factory for ShinyPages::Template
#
# Copyright 2009-2020 Denny de la Haye (https://denny.me)
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

FactoryBot.define do
  factory :page_template, class: 'ShinyPages::Template' do
    name     { Faker::Books::CultureSeries.unique.culture_ship }
    filename { 'an_example' }
  end
end
