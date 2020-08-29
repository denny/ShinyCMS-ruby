# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for mailing lists - ShinyLists plugin for ShinyCMS
FactoryBot.define do
  factory :mailing_list, class: 'ShinyLists::List' do
    internal_name { Faker::Books::CultureSeries.unique.culture_ship }
  end
end
