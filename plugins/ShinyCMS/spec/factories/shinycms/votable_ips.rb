# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for VotableIP model
FactoryBot.define do
  factory :votable_ip, class: 'ShinyCMS::VotableIP' do
    ip_address { Faker::Internet.unique.ip_v4_address }
  end
end
