# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Comment model
FactoryBot.define do
  factory :comment, aliases: [ :top_level_comment ], class: 'ShinyCMS::Comment' do
    sequence( :number )
    title  { Faker::Books::CultureSeries.unique.culture_ship }
    body   { Faker::Lorem.paragraph }

    association :discussion

    association :author, factory: :anonymous_author
  end

  factory :nested_comment, parent: :comment do
    association :parent, factory: :top_level_comment
  end
end
