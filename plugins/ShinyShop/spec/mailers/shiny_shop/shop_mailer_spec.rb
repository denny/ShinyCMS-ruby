# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the shop mailer
RSpec.describe ShinyShop::ShopMailer, type: :mailer do
  after do
    ShinyCMS::FeatureFlag.disable :send_emails
  end

  describe '.confirmation' do
    it 'generates an email to them' do
      ShinyCMS::FeatureFlag.enable :send_emails
      email = described_class.confirmation 'TEST@shinycms.org'

      expect( email.subject ).to eq 'Thank you!'
    end
  end
end
