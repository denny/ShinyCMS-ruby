# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

RSpec.configure do |config|
  config.before :all do
    # Configure Faker to reset the uniqueness generators between each test
    Faker::UniqueGenerator.clear

    # These two cause false positives for .not_in tests when 'Lasting Damage II' is in same dataset
    Faker::Books::CultureSeries.unique.exclude :culture_ship, [], [ 'Lasting Damage', 'Lasting Damage I' ]
  end
end
