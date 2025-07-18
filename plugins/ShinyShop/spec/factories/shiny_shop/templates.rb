# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for product templates - ShinyShop plugin for ShinyCMS
module ShinyShop
  FactoryBot.define do
    factory :product_template, class: 'ShinyShop::Template' do
      name     { Faker::Books::CultureSeries.unique.culture_ship }
      filename { 'an_example' }
    end
  end
end
