# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for template elements - ShinyNewsletters plugin for ShinyCMS
module ShinyNewsletters
  FactoryBot.define do
    factory :newsletter_template_element, class: 'ShinyNewsletters::TemplateElement' do
      name { Faker::Books::CultureSeries.unique.culture_ship }
    end
  end
end
