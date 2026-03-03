# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

RSpec.shared_examples ShinyCMS::HasEmail do
  context 'when address is confirmed and is not on Do Not Contact list' do
    describe '.ok_to_email?' do
      it 'returns true' do
        addressee.confirm

        allow( ShinyCMS::DoNotContact ).to receive( :listed? ).and_return false

        expect( addressee.ok_to_email? ).to be true
      end
    end
  end

  context 'when address is confirmed but is on Do Not Contact list' do
    describe '.not_ok_to_email?' do
      it 'returns true' do
        addressee.confirm

        allow( ShinyCMS::DoNotContact ).to receive( :listed? ).and_return true

        expect( addressee.not_ok_to_email? ).to be true
      end
    end
  end

  describe 'when address is not confirmed' do
    describe '.not_ok_to_email?' do
      it 'returns true' do
        allow( addressee ).to receive( :confirmed_at ).and_return nil

        allow( ShinyCMS::DoNotContact ).to receive( :listed? ).and_return false

        expect( addressee.not_ok_to_email? ).to be true
      end
    end
  end
end
