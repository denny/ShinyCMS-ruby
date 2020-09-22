# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Configure Faker to reset the uniqueness generators between each test
RSpec.configure do |config|
  config.before :all do
    Faker::UniqueGenerator.clear
  end
end
