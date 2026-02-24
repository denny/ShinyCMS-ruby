# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factories for page template elements - ShinyPages plugin for ShinyCMS
module ShinyShop
  FactoryBot.define do
    factory :product_template_element, class: 'ShinyShop::TemplateElement' do
      name { Faker::Books::CultureSeries.unique.civs.underscore }

      association :template, factory: :product_template
    end
  end
end
