# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Tests for behaviour mixed-in by the HasEmail concern
RSpec.shared_examples ShinyCMS::HasEmail do
  describe '.not_ok_to_email?' do
    it 'returns true if the email is not confirmed' do
      allow( addressee ).to receive( :confirmed_at ).and_return nil

      expect( addressee.not_ok_to_email? ).to be true
    end

    it 'returns true if the email is on the Do Not Contact list' do
      addressee.confirm

      allow( ShinyCMS::DoNotContact ).to receive( :list_includes? ).and_return true

      expect( addressee.not_ok_to_email? ).to be true
    end
  end

  describe '.okay_to_email?' do
    it 'returns true if the email is confirmed' do
      addressee.confirm

      expect( addressee.ok_to_email? ).to be true
    end
  end
end
