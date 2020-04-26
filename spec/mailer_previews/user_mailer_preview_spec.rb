# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserMailerPreview', type: :request do
  before :each do
    admin = create :email_admin
    sign_in admin
  end

  describe '.confirmation_instructions' do
    it 'shows the confirmation instructions email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'user_mailer_preview-confirmation_instructions'
      )

      expect( response.body )
        .to have_content I18n.t( 'user_mailer.confirmation_instructions.subject' )
    end
  end

  describe '.reset_password' do
    it 'shows the password reset email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'user_mailer_preview-reset_password'
      )

      expect( response.body )
        .to have_content I18n.t( 'user_mailer.reset_password.subject' )
    end
  end

  describe '.password_changed' do
    it 'shows the password changed email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'user_mailer_preview-password_changed'
      )

      expect( response.body )
        .to have_content I18n.t( 'user_mailer.password_changed.subject' )
    end
  end

  describe '.email_changed' do
    it 'shows the email address changed notification email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'user_mailer_preview-email_changed'
      )

      expect( response.body )
        .to have_content I18n.t( 'user_mailer.email_changed.subject' )
    end
  end

  describe '.unlock_instructions' do
    it 'shows the unlock instructions email' do
      get rails_email_preview.rep_email_path(
        preview_id: 'user_mailer_preview-unlock_instructions'
      )

      expect( response.body )
        .to have_content I18n.t( 'user_mailer.unlock_instructions.subject' )
    end
  end
end
