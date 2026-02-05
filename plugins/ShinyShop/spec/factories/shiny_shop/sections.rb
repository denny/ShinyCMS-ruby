# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factories for shop sections - ShinyShop plugin for ShinyCMS
module ShinyShop
  FactoryBot.define do
    factory :shop_section, class: 'ShinyShop::Section', aliases: [ :top_level_shop_section ] do
      internal_name { Faker::Books::CultureSeries.unique.culture_ship }
      slug   { internal_name.dup.parameterize }

      trait :hidden do
        show_on_site { false }
      end
    end

    factory :nested_shop_section, parent: :shop_section do
      association :section, factory: :shop_section
    end
  end
end
