# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the RailsEmailPreview engine, which powers admin previews of site emails
RSpec.describe RailsEmailPreview, type: :request do
  before :each do
    admin = create :mailer_admin
    sign_in admin
  end

  describe 'when I load the index page' do
    it 'shows the list of emails' do
      get rails_email_preview.rep_emails_path

      expect( response.body ).to have_title I18n.t( 'rails_email_preview.emails.index.title' ).titlecase
      expect( response.body ).to have_link text: I18n.t( 'devise.mailer.confirmation_instructions.subject' )
    end
  end
end
