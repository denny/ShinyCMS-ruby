# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Allow use of shorter FactoryBot syntax in tests - `create :foo` instead of `FactoryBot.create(:foo)`
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
