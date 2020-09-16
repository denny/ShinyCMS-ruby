# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factories for page elements - ShinyPages plugin for ShinyCMS
module ShinyPages
  FactoryBot.define do
    factory :page_element, class: 'ShinyPages::PageElement' do
      name { Faker::Books::CultureSeries.unique.civs.underscore }
    end

    factory :short_text_page_element, parent: :page_element do
      element_type { 'short_text' }
    end

    factory :long_text_page_element, parent: :page_element do
      element_type { 'long_text' }
    end

    factory :image_page_element, parent: :page_element do
      element_type { 'image' }
    end

    factory :html_page_element, parent: :page_element do
      element_type { 'html' }
    end
  end
end
