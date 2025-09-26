# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factories for product elements - ShinyShop plugin for ShinyCMS
module ShinyShop
  FactoryBot.define do
    factory :product_element, class: 'ShinyShop::ProductElement' do
      name { Faker::Books::CultureSeries.unique.civs.underscore }

      association :product
    end
  end
end
