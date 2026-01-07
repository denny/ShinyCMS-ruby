# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factories for shop products - ShinyShop plugin for ShinyCMS
module ShinyShop
  FactoryBot.define do
    factory :product, class: 'ShinyShop::Product', aliases: [ :top_level_product ] do
      internal_name { Faker::Books::CultureSeries.unique.culture_ship }

      association :template, factory: :product_template

      price { 666 }

      trait :hidden do
        show_on_site { false }
      end
    end

    factory :product_in_section, parent: :product do
      association :section, factory: :top_level_shop_section
    end

    factory :product_in_nested_section, parent: :product do
      association :section, factory: :nested_shop_section
    end
  end
end
