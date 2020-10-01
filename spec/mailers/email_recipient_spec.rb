# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the email recipient mailer (email address verification)
RSpec.describe EmailRecipientMailer, type: :mailer do
  describe '.confirm' do
    it 'generates an email to an unconfirmed email recipient' do
      recipient = create :email_recipient
      recipient.set_confirm_token

      email = EmailRecipientMailer.confirm( recipient )

      subject = I18n.t(
        'email_recipient_mailer.confirm.subject',
        site_name: Setting.get( :site_name )
      )

      expect( email.subject ).to eq subject
    end
  end
end
