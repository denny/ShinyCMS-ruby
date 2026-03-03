# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for DoNotContact model (one way encrypted email addresses to check against before we send anything)
FactoryBot.define do
  factory :do_not_contact, class: 'ShinyCMS::DoNotContact' do
    email { Faker::Internet.unique.email }
  end
end
