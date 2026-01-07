# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factories for shop products - ShinyShop plugin for ShinyCMS
module ShinyShop
  FactoryBot.define do
    factory :product, class: 'ShinyShop::Product' do
      internal_name { Faker::Books::CultureSeries.unique.culture_ship }
      price { 666 }
    end
  end
end
