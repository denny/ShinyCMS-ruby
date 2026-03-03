# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Shared test code, for testing methods mixed-in by the ShinyCMS::HasToken concern
RSpec.shared_examples ShinyCMS::HasToken do
  describe 'token generation' do
    it 'generates a token when saved, if none is present' do
      tokenised.token = nil
      expect( tokenised.token ).to be_blank

      tokenised.save!
      expect( tokenised.token ).to match %r{[-\w]+}
    end
  end
end
