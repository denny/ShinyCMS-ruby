# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for ShinyCMS 'do not contact' feature
RSpec.describe ShinyCMS::DoNotContactController, type: :request do
  describe 'GET /email/do-not-contact' do
    it 'displays the do-not-contact form' do
      get shinycms.do_not_contact_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.do_not_contact.new.title' )
    end
  end

  describe 'POST /email/do-not-contact' do
    it 'adds a valid email to the do-not-contact list' do
      post shinycms.do_not_contact_path, params: { email: Faker::Internet.unique.email }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.do_not_contact_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.do_not_contact.new.title' )
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.do_not_contact.create.success' )
    end

    it 'lets people know if they try to add a duplicate email to the do-not-contact list' do
      email_address = Faker::Internet.unique.email

      create :do_not_contact, email: email_address

      post shinycms.do_not_contact_path, params: { email: email_address }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.do_not_contact_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.do_not_contact.new.title' )
      expect( response.body ).to have_css '.notices', text: I18n.t( 'shinycms.do_not_contact.create.duplicate' )
    end

    it 'fails to add an invalid email to the do-not-contact list' do
      post shinycms.do_not_contact_path, params: { email: 'This is not an email address' }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shinycms.do_not_contact_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shinycms.do_not_contact.new.title' )
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shinycms.do_not_contact.create.failure' )
    end
  end
end
