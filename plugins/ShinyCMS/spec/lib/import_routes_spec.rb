# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

require_relative '../../lib/import_routes'

# Tests for the import_routes method
RSpec.describe 'import_routes', type: :helper do
  describe 'when the routes partial file does not exist' do
    it 'raises an error' do
      expect { import_routes( partial: :no_such_file ) }.to raise_error ArgumentError
    end
  end
end
