# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factories for page sections - ShinyPages plugin for ShinyCMS
module ShinyPages
  FactoryBot.define do
    factory :page_section, class: 'ShinyPages::Section', aliases: [ :top_level_section ] do
      internal_name { Faker::Books::CultureSeries.unique.culture_ship }
      slug   { internal_name.dup.parameterize }

      trait :hidden do
        show_on_site { false }
      end
    end

    factory :nested_page_section, parent: :page_section do
      association :section, factory: :page_section
    end
  end
end
