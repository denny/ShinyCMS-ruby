# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Subscription model
FactoryBot.define do
  factory :consent do
    purpose_type { 'Subscription' }
    purpose_id { 1 }
    action { 'checkbox' }
    wording { 'I would like to receive email relating to any and all of the lists I have checked above' }
    url { 'https://example.com/lists' }
  end
end
