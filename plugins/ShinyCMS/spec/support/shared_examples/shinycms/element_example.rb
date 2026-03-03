# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Shared test code, for testing the methods mixed-in by the ShinyCMS::Element concern
RSpec.shared_examples ShinyCMS::Element do
  describe '.format_name' do
    it 'updates the record to have a valid element name' do
      # rubocop:disable Rails/SkipsModelValidations
      element.update_attribute( :name, 'Format Me Please!' )
      # rubocop:enable Rails/SkipsModelValidations
      element.format_name

      expect( element.name ).to eq 'format_me_please'
    end
  end
end
