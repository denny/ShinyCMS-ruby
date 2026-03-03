# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This is my slowest test file by almost an order of magnitude, so ...
return if ENV['CI'] == 'true'

require 'i18n/tasks'

# Tests to check i18n strings are all present and current
RSpec.describe I18n do
  let( :i18n         ) { described_class::Tasks::BaseTask.new }
  let( :missing_keys ) { i18n.missing_keys                    }
  let( :unused_keys  ) { i18n.unused_keys                     }

  it 'does not have missing keys' do
    error_message = "Missing #{missing_keys.leaves.count} i18n keys, run `i18n-tasks missing' to show them"

    expect( missing_keys ).to be_empty, error_message
  end

  it 'does not have unused keys' do
    error_message = "#{unused_keys.leaves.count} unused i18n keys, run `i18n-tasks unused' to show them"

    expect( unused_keys ).to be_empty, error_message
  end
end
