# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ahoy email tracking', type: :request do
  describe 'GET /ahoy/messages/xxx/open.gif' do
    it 'it records an open event' do
      message = create :ahoy_message

      get "/ahoy/messages/#{message.token}/open.gif"

      expect( response ).to have_http_status :ok
    end
  end

  describe 'GET /ahoy/messages/xxx/click' do
    it 'it records a click event' do
      message = create :ahoy_message

      url = 'http://example.com'
      signature = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha1'), AhoyEmail.secret_token, url
      )
      get "/ahoy/messages/#{message.token}/click?url=http%3A%2F%2Fexample.com&signature=#{signature}"

      expect( response ).to have_http_status :found
    end
  end
end
