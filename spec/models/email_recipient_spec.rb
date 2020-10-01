# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for EmailRecipient model
RSpec.describe EmailRecipient, type: :model do
  context 'instance methods' do
    describe '.confirm' do
      it 'successfully confirms a matching email recipient' do
        recipient = create :unconfirmed_email_recipient

        expect( recipient.confirm ).to be true
      end

      it 'fails if the confirm token has expired' do
        recipient = create :unconfirmed_email_recipient, confirm_sent_at: 1.month.ago

        expect( recipient.confirm ).to be false
      end
    end

    describe '.confirmed?' do
      it 'returns true if the recipient has confirmed their email address' do
        recipient = create :confirmed_email_recipient

        expect( recipient.confirmed? ).to be true
      end

      it 'returns false if the recipient has not confirmed their email address' do
        recipient = create :unconfirmed_email_recipient

        expect( recipient.confirmed? ).to be false
      end
    end

    describe '.confirm_expired?' do
      it 'returns true if the confirm_token has expired' do
        recipient = create :unconfirmed_email_recipient, confirm_sent_at: 1.month.ago

        expect( recipient.confirm_expired? ).to be true
      end

      it 'returns false if the confirm_token has not expired' do
        recipient = create :unconfirmed_email_recipient

        expect( recipient.confirm_expired? ).to be false
      end
    end
  end

  context 'concerns' do
    it_should_behave_like ShinyToken do
      let( :tokenised ) { create :email_recipient }
    end
  end
end
