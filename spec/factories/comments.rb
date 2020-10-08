# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Comment model
FactoryBot.define do
  factory :comment do
    sequence( :number )
    title  { Faker::Books::CultureSeries.unique.culture_ship }
    body   { Faker::Lorem.paragraph }
    author_type { 'anonymous' }

    association :discussion
  end

  factory :top_level_comment, parent: :comment do
    parent_id { nil }
  end

  factory :nested_comment, parent: :comment do
  end
end
