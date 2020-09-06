# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for EmailRecipient model (no user account but we want to send them email - newsletters, reply notifications, etc)
FactoryBot.define do
  factory :email_recipient do
    name  { Faker::Books::CultureSeries.unique.culture_ship }
    email { Faker::Internet.unique.email }
  end
end
