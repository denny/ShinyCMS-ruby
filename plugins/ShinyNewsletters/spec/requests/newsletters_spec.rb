# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for main site newsletter features

RSpec.describe 'Newsletters', type: :request do
  describe 'GET /newsletters' do
    it 'displays a list of newsletters sent to this subscriber recently' do
      user1 = create :user
      sign_in user1

      list1 = create :mailing_list
      list2 = create :mailing_list
      create :mailing_list_subscription, list: list1, subscriber: user1
      create :mailing_list_subscription, list: list2, subscriber: user1

      create :newsletter_send_sent, list: list1
      create :newsletter_send_sent, list: list2
      create :newsletter_send,      list: list1

      get shiny_newsletters.user_view_newsletters_path

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.newsletters.index.title' ).titlecase
    end

    it 'displays an error message if the subscriber is not found' do
      get shiny_newsletters.token_view_newsletters_path( 'not-a-real-token' )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title I18n.t( 'shiny_newsletters.newsletters.index.title' ).titlecase
      expect( response.body ).to have_css '.alerts', text: I18n.t( 'shiny_newsletters.newsletters.index.subscriber_not_found' )
    end
  end

  describe 'GET /newsletters/:id' do
    it 'displays the newsletter in the browser' do
      user1 = create :user
      sign_in user1

      list1 = create :mailing_list
      create :mailing_list_subscription, list: list1, subscriber: user1

      send1 = create :newsletter_send_sent, list: list1

      get shiny_newsletters.user_view_newsletter_path( send1.sent_year, send1.sent_month, send1.edition.slug )

      expect( response      ).to have_http_status :ok
      expect( response.body ).to have_title send1.edition.name
    end
  end
end
