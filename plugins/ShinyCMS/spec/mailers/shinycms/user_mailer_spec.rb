# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for the user mailer (used by Devise)
RSpec.describe ShinyCMS::UserMailer, type: :mailer do
  before do
    ShinyCMS::FeatureFlag.enable :send_emails
  end

  after do
    ShinyCMS::FeatureFlag.disable :send_emails
  end

  let( :user  ) { create :user }
  let( :token ) { 'TEST_TOKEN' }

  let( :site_name ) { ShinyCMS::Setting.get( :site_name ) || I18n.t( 'site_name' ) }

  def subject_for( method )
    I18n.t( "shinycms.user_mailer.#{method}.subject", site_name: site_name )
  end

  describe '.confirmation_instructions' do
    it 'generates confirmation instructions email to user email address' do
      email = described_class.confirmation_instructions( user, token )

      expect( email.to.first ).to eq user.email
      expect( email.subject  ).to eq subject_for :confirmation_instructions
    end
  end

  describe '.email_changed_instructions' do
    it 'generates email-changed instructions email for user' do
      email = described_class.email_changed_instructions( user )

      expect( email.to.first ).to eq user.email
      expect( email.subject  ).to eq subject_for :email_changed_instructions
    end
  end

  describe '.password_changed_instructions' do
    it 'generates password changed email for user' do
      email = described_class.password_changed_instructions( user )

      expect( email.to.first ).to eq user.email
      expect( email.subject  ).to eq subject_for :password_changed_instructions
    end
  end

  describe '.reset_password_instructions' do
    it 'generates password reset instructions email to user email address' do
      email = described_class.reset_password_instructions( user, token )

      expect( email.to.first ).to eq user.email
      expect( email.subject  ).to eq subject_for :reset_password_instructions
    end
  end

  describe '.unlock_instructions' do
    it 'generates unlock instructions email to user email address' do
      email = described_class.unlock_instructions( user, token )

      expect( email.to.first ).to eq user.email
      expect( email.subject  ).to eq subject_for :unlock_instructions
    end
  end
end
