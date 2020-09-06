# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Consent model (holds details of things users can agree to, e.g. 'subscribe to mailing list')
FactoryBot.define do
  factory :consent_version do
    name { Faker::Books::CultureSeries.unique.culture_ship }
    display_text { Faker::Lorem.paragraph }
  end
end
