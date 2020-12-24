# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for user profiles
module ShinyProfiles
  FactoryBot.define do
    factory :user_profile, class: 'ShinyProfiles::Profile' do
      public_name { Faker::Name.unique.name }
      show_on_site { true }
      show_in_gallery { true }
      show_to_unauthenticated { true }

      association :user
    end
  end
end
