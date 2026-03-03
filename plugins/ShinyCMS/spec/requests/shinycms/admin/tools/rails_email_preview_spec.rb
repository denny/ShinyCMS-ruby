# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the RailsEmailPreview engine, which powers admin previews of site emails
RSpec.describe RailsEmailPreview, type: :request do
  before do
    admin = create :tools_admin
    sign_in admin
  end

  let( :site_name ) { ShinyCMS::Setting.get( :site_name ) || I18n.t( 'site_name' ) }

  describe 'when I load the index page' do
    it 'shows the list of emails' do
      get rails_email_preview.rep_emails_path

      expect( response.body ).to have_title I18n.t( 'shinycms.admin.rails_email_preview.emails.index.title' ).titlecase
      expect( response.body ).to have_link 'Confirmation instructions'
      # expect( response.body ).to have_link text: I18n.t( 'shinycms.user_mailer.confirmation_instructions.subject', site_name: site_name )
    end
  end
end
