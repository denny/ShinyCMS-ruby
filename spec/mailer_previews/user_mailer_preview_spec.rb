# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for previewing the user mailer (powered by RailsEmailPreview)
RSpec.describe UserMailerPreview, type: :request do
  before do
    admin = create :mailer_admin
    sign_in admin

    @site_name = ::Setting.get( :site_name ) || I18n.t( 'site_name' )
  end

  describe '.confirmation_instructions' do
    it 'shows the confirmation instructions email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'user_mailer_preview-confirmation_instructions'
      )

      expect( response.body )
        .to have_content I18n.t( 'user_mailer.confirmation_instructions.subject', site_name: @site_name )
    end
  end

  describe '.reset_password_instructions' do
    it 'shows the password reset email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'user_mailer_preview-reset_password_instructions'
      )

      expect( response.body )
        .to have_content I18n.t( 'user_mailer.reset_password_instructions.subject', site_name: @site_name )
    end
  end

  describe '.password_changed_instructions' do
    it 'shows the password changed email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'user_mailer_preview-password_changed_instructions'
      )

      expect( response.body )
        .to have_content I18n.t( 'user_mailer.password_changed_instructions.subject', site_name: @site_name )
    end
  end

  describe '.email_changed_instructions' do
    it 'shows the email address changed notification email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'user_mailer_preview-email_changed_instructions'
      )

      expect( response.body )
        .to have_content I18n.t( 'user_mailer.email_changed_instructions.subject', site_name: @site_name )
    end
  end

  describe '.unlock_instructions' do
    it 'shows the unlock instructions email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'user_mailer_preview-unlock_instructions'
      )

      expect( response.body )
        .to have_content I18n.t( 'user_mailer.unlock_instructions.subject', site_name: @site_name )
    end
  end
end
