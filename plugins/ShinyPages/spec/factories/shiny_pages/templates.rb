# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for page templates - ShinyPages plugin for ShinyCMS
module ShinyPages
  FactoryBot.define do
    factory :page_template, class: 'ShinyPages::Template' do
      name     { Faker::Books::CultureSeries.unique.culture_ship }
      filename { 'an_example' }
    end
  end
end
