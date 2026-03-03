# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for EmailRecipient model
RSpec.describe ShinyCMS::EmailRecipient, type: :model do
  describe 'instance methods' do
    describe '.confirm' do
      it 'successfully confirms a matching email recipient' do
        recipient = create :email_recipient

        expect( recipient.confirm ).to be true
      end

      it 'fails if the confirm token has expired' do
        recipient = create :email_recipient
        recipient.set_confirm_token
        recipient.update!( confirm_sent_at: 1.month.ago )

        expect( recipient.confirm ).to be false
      end
    end

    describe '.confirmed?' do
      it 'returns true if the recipient has confirmed their email address' do
        recipient = create :email_recipient, :confirmed

        expect( recipient.confirmed? ).to be true
      end

      it 'returns false if the recipient has not confirmed their email address' do
        recipient = create :email_recipient

        expect( recipient.confirmed? ).to be false
      end
    end

    describe '.confirm_expired?' do
      it 'returns true if the confirm_token has expired' do
        recipient = create :email_recipient
        recipient.set_confirm_token
        recipient.update!( confirm_sent_at: 1.month.ago )

        expect( recipient.confirm_expired? ).to be true
      end

      it 'returns false if the confirm_token has not expired' do
        recipient = create :email_recipient

        expect( recipient.confirm_expired? ).to be false
      end
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyCMS::ProvidesDemoSiteData do
      let( :model ) { described_class }
    end

    it_behaves_like ShinyCMS::HasEmail do
      let( :addressee ) { create :email_recipient }
    end

    it_behaves_like ShinyCMS::HasToken do
      let( :tokenised ) { create :email_recipient }
    end
  end
end
