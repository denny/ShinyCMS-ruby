# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factories for page elements - ShinyPages plugin for ShinyCMS
module ShinyPages
  FactoryBot.define do
    factory :page_element, class: 'ShinyPages::PageElement' do
      name { Faker::Books::CultureSeries.unique.civs.underscore }

      association :page
    end
  end
end
