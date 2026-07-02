# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for access control group memberships
module ShinyAccess
  FactoryBot.define do
    factory :access_membership, class: Membership do
      began_at { 1.day.ago }

      association :group, factory: :access_group
      association :user

      trait :ended do
        ended_at { 1.hour.ago }
      end
    end
  end
end
