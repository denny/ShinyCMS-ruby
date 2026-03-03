# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for main site features for email recipients
RSpec.describe ShinyCMS::EmailRecipientsController, type: :request do
  before do
    create :top_level_page
  end

  describe 'GET /email/confirm/:token' do
    it 'confirms the email address if the token is valid' do
      recipient = create :email_recipient

      get shinycms.confirm_email_path( recipient.confirm_token )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.email_recipients.confirm.success' )
    end

    it "shows an error message if the token doesn't exist" do
      get shinycms.confirm_email_path( SecureRandom.uuid )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shinycms.email_recipients.confirm.token_not_found' )
    end

    it 'shows an error message if the token has expired' do
      recipient = create :email_recipient
      recipient.set_confirm_token
      recipient.update!( confirm_sent_at: 1.month.ago )

      get shinycms.confirm_email_path( recipient.confirm_token )

      expect( response ).to have_http_status :found
      expect( response ).to redirect_to main_app.root_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shinycms.email_recipients.confirm.token_expired' )
    end
  end
end
