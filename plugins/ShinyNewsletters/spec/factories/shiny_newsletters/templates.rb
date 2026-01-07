# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for newsletter templates - ShinyNewsletters plugin for ShinyCMS
module ShinyNewsletters
  FactoryBot.define do
    factory :newsletter_template, class: 'ShinyNewsletters::Template' do
      name { Faker::Books::CultureSeries.unique.culture_ship }
      filename { 'an_example' }
    end

    factory :invalid_newsletter_template, parent: :newsletter_template do
      filename { 'bad_mjml' }
    end
  end
end
