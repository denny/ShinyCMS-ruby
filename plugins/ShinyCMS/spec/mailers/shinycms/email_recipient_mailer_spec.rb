# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinyCMS::EmailRecipientMailer, type: :mailer do
  before do
    ShinyCMS::FeatureFlag.enable :send_emails
  end

  after do
    ShinyCMS::FeatureFlag.disable :send_emails
  end

  describe '.confirm' do
    context 'when the email address is contactable' do
      it 'generates an email to an unconfirmed email recipient' do
        recipient = create :email_recipient
        recipient.set_confirm_token

        message = described_class.with( recipient: recipient ).confirm

        subject = I18n.t(
          'shinycms.email_recipient_mailer.confirm.subject',
          site_name: ShinyCMS::Setting.get( :site_name ) || I18n.t( 'site_name' )
        )

        expect( message.subject ).to eq subject
        expect( message.perform_deliveries ).to be true
      end
    end

    context 'when the email address is on our Do Not Contact list' do
      it 'does not generate an email to them' do
        recipient = create :email_recipient
        recipient.set_confirm_token

        create :do_not_contact, email: recipient.email

        message = described_class.with( recipient: recipient ).confirm

        expect( message.perform_deliveries ).to be false
      end
    end
  end
end
