# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Factory for Subscription model (part of mailing list features)
FactoryBot.define do
  factory :subscription do
    subscriber_type { 'EmailRecipient' }
  end
end
