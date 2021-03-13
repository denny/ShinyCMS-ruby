# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

RSpec.describe ShinyCMS::Mailer, type: :mailer do
  describe 'enforce_feature_flags' do
    context 'when send_emails is disabled' do
      it 'returns false' do
        skip 'whut'

        recipient = create :email_recipient

        ShinyCMS::FeatureFlag.disable :send_emails

        mailer = ShinyCMS::EmailRecipientMailer

        mailer.with( recipient: recipient ).confirm

        expect( mailer.perform_deliveries ).to be false
      end
    end
  end
end
