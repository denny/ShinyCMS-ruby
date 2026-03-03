# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Shared test code, for testing methods mixed-in by ShinyCMS::ProvidesDemoSiteData concern
RSpec.shared_examples 'ShinyCMS::Comment.author' do
  describe '.name' do
    it 'returns a string' do
      expect( author.name ).to be_a String
    end
  end

  describe '.email' do
    it 'returns either a valid email address, or nil' do
      expect( EmailAddress.valid?( author.email ) ).to be true if author.email.present?
      expect( author.email.nil? ).to be true if author.email.blank?
    end
  end
end
