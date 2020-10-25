# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factories for pages - ShinyPages plugin for ShinyCMS
module ShinyPages
  FactoryBot.define do
    factory :page, class: 'ShinyPages::Page', aliases: [ :top_level_page ] do
      internal_name { Faker::Books::CultureSeries.unique.culture_ship }
      association :template, factory: :page_template

      trait :hidden do
        show_on_site { false }
      end
    end

    factory :page_in_section, parent: :page do
      association :section, factory: :top_level_section
    end

    factory :page_in_nested_section, parent: :page do
      association :section, factory: :nested_page_section
    end

    factory :page_with_element_type_content, parent: :page do
      after :create do |page|
        page.elements.second.update!( content: 'SHORT!' )
        page.elements.third.update!(  content: 'LONG!'  )
        page.elements.fourth.update!( content: 'HTML!'  )
      end
    end
  end
end
