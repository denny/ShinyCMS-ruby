# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for email open/click tracking (powered by Ahoy::Email)
RSpec.describe 'Ahoy email tracking', type: :request do
  describe 'GET /ahoy/messages/xxx/open.gif' do
    it 'records an open event' do
      message = create :ahoy_message

      expect( message.opened_at ).to be_nil

      get "/ahoy/messages/#{message.token}/open.gif"

      expect( response ).to have_http_status :ok
      expect( message.reload.opened_at ).to be_present
    end
  end

  describe 'GET /ahoy/messages/xxx/click' do
    it 'records a click event' do
      message = create :ahoy_message

      url = 'http://example.com'
      signature = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new( 'sha1' ), AhoyEmail.secret_token, url
      )

      expect( message.clicked_at ).to be_nil

      get "/ahoy/messages/#{message.token}/click?url=http%3A%2F%2Fexample.com&signature=#{signature}"

      expect( response ).to have_http_status :found
      expect( message.reload.clicked_at ).to be_present
    end
  end
end
