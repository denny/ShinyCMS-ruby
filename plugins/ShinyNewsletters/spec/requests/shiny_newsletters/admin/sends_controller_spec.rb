# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for newsletter send admin features

RSpec.describe ShinyNewsletters::Admin::SendsController, type: :request do
  before do
    admin = create :newsletter_send_admin
    sign_in admin
  end

  describe 'GET /admin/newsletters/sends' do
    it 'fetches the list of sends in the admin area' do
      send1 = create :newsletter_send
      send2 = create :newsletter_send_sent
      send3 = create :newsletter_send_sending

      get shiny_newsletters.sends_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.index.title' ).titlecase
      expect( response.body ).to have_css 'td', text: send1.edition.internal_name
      expect( response.body ).to have_css 'td', text: send3.edition.internal_name
      expect( response.body ).not_to have_css 'td', text: send2.edition.internal_name
    end
  end

  describe 'GET /admin/newsletters/sends/sent' do
    it 'displays a list of recently sent newsletters' do
      send1 = create :newsletter_send
      send2 = create :newsletter_send_sent
      send3 = create :newsletter_send_sending

      get shiny_newsletters.sent_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.sent.title' ).titlecase
      expect( response.body ).to have_css 'td', text: send2.edition.internal_name
      expect( response.body ).not_to have_css 'td', text: send1.edition.internal_name
      expect( response.body ).not_to have_css 'td', text: send3.edition.internal_name
    end
  end

  describe 'GET /admin/newsletters/sends/search?q=2001-12-31' do
    it 'fetches the list of matching sends' do
      send1 = create :newsletter_send_sent, finished_sending_at: 2.days.ago
      send2 = create :newsletter_send_sent, finished_sending_at: 1.day.ago

      get shiny_newsletters.search_sends_path, params: { q: 2.days.ago.strftime( '%F' ) }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.index.title' ).titlecase

      expect( response.body ).to     have_css 'td', text: send1.edition.internal_name
      expect( response.body ).not_to have_css 'td', text: send2.edition.internal_name
    end
  end

  describe 'GET /admin/newsletters/sends/123' do
    it 'displays the details of a send which has completed (or been cancelled)' do
      send1 = create :newsletter_send_sent

      get shiny_newsletters.send_path( send1 )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.show.title' ).titlecase
      expect( response.body ).to have_css 'td', text: send1.edition.internal_name
    end
  end

  describe 'GET /admin/newsletters/sends/new' do
    it 'loads the form to add a new send' do
      get shiny_newsletters.new_send_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.new.title' ).titlecase
    end
  end

  describe 'POST /admin/newsletters/sends' do
    it 'fails when the form is submitted without all the details' do
      list1 = create :mailing_list

      post shiny_newsletters.sends_path, params: {
        send: {
          list_id: list1.id
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.new.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_newsletters.admin.sends.create.failure' )
    end

    it 'adds a new send when the form is submitted' do
      list1 = create :mailing_list
      edition1 = create :newsletter_edition

      post shiny_newsletters.sends_path, params: {
        send: {
          list_id:    list1.id,
          edition_id: edition1.id
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.edit_send_path( ShinyNewsletters::Send.last )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.sends.create.success' )
    end
  end

  describe 'GET /admin/newsletters/sends/:id' do
    it 'loads the form to edit an existing send' do
      send1 = create :newsletter_send

      get shiny_newsletters.edit_send_path( send1 )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.edit.title' ).titlecase
    end
  end

  describe 'PUT /admin/newsletters/sends/:id' do
    it 'fails to update the send when submitted without a list' do
      send1 = create :newsletter_send

      put shiny_newsletters.send_path( send1 ), params: {
        send: {
          list_id: nil
        }
      }

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-danger', text: I18n.t( 'shiny_newsletters.admin.sends.update.failure' )
    end

    it 'updates the send when the form is submitted' do
      edition1 = create :newsletter_edition
      edition2 = create :newsletter_edition
      send1 = create :newsletter_send, edition: edition1

      put shiny_newsletters.send_path( send1 ), params: {
        send: {
          list_id:    send1.list.id,
          edition_id: edition2.id
        }
      }

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.edit_send_path( send1 )
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.edit.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.sends.update.success' )
      expect( response.body ).to have_field 'send[edition_id]', text: edition2.internal_name
    end
  end

  describe 'PUT /admin/newsletters/sends/:id/start' do
    it 'starts sending the specified send' do
      list1 = create :mailing_list, subscriber_count: 1
      send1 = create :newsletter_send, list: list1

      put shiny_newsletters.start_send_path( send1 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.sends_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.sends.start_sending.success' )
    end
  end

  describe 'PUT /admin/newsletters/sends/:id/cancel' do
    it 'cancels the specified (currently sending) send' do
      send1 = create :newsletter_send

      put shiny_newsletters.cancel_send_path( send1 )

      expect( response      ).to have_http_status :found
      expect( response      ).to redirect_to shiny_newsletters.sends_path
      follow_redirect!
      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.admin.sends.index.title' ).titlecase
      expect( response.body ).to have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.sends.cancel_sending.success' )
      # TODO: No distinction between 'finished' and 'cancelled' currently
      # expect( response.body ).to have_css 'td', text: 'Cancelled'
    end
  end

  describe 'DELETE /admin/newsletters/sends/:id' do
    it 'deletes the specified send' do
      s1 = create :newsletter_send
      s2 = create :newsletter_send
      s3 = create :newsletter_send

      delete shiny_newsletters.send_path( s2 )

      expect( response      ).to     have_http_status :found
      expect( response      ).to     redirect_to shiny_newsletters.sends_path
      follow_redirect!
      expect( response      ).to     have_http_status :ok
      expect( response.body ).to     have_title I18n.t( 'shiny_newsletters.admin.sends.index.title' ).titlecase
      expect( response.body ).to     have_css '.alert-success', text: I18n.t( 'shiny_newsletters.admin.sends.destroy.success' )
      expect( response.body ).to     have_css 'td', text: s1.edition.internal_name
      expect( response.body ).not_to have_css 'td', text: s2.edition.internal_name
      expect( response.body ).to     have_css 'td', text: s3.edition.internal_name
    end
  end
end
