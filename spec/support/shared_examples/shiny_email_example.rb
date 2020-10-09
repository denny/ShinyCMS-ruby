# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Shared test code, for testing methods and behaviour mixed-in by the ShinyEmail concern
RSpec.shared_examples ShinyEmail do
  describe '.do_not_email?' do
    it 'returns true if the email is not confirmed' do
      allow( addressee ).to receive( :confirmed_at ) { nil }

      expect( addressee.do_not_email? ).to be true
    end

    it 'returns false if the email is confirmed' do
      addressee.confirm

      expect( addressee.do_not_email? ).to be false
    end
  end
end
