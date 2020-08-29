# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Edition model - ShinyNewsletters plugin for ShinyCMS
FactoryBot.define do
  factory :newsletter_edition, class: 'ShinyNewsletters::Edition' do
    internal_name { Faker::Books::CultureSeries.unique.culture_ship }
    association :template, factory: :newsletter_template
  end
end
