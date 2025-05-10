# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for stripe
RSpec.describe StripeEvent::WebhookController, type: :request do
  let( :secret1 ) { ENV.fetch( 'STRIPE_SIGNING_SECRET' ) }
  # let( :secret2 ) { 'secret2' }
  # let( :charge_succeeded ) { stub_event('evt_charge_succeeded') }

  describe 'with Stripe::Event' do
    it 'creates an event' do
      webhook_with_signature(
        {
          id:     'cs_test_a1EpQUx46ZmXVRrlDCpDTyy7DNsXwDmc3IRH12Bf8KDAm0h35Aeh18IDlG',
          object: 'checkout.session'
        }
      )

      # binding.pry

      expect( response      ).to have_http_status :ok
      expect( response.body ).to include 'No products found'
    end
  end

  # def stub_event(identifier)
  #   JSON.parse(File.read("spec/support/fixtures/#{identifier}.json"))
  # end

  def generate_signature( params, secret )
    payload   = params.to_json
    timestamp = Time.now.utc

    signer    = Stripe::Webhook::Signature.method( :compute_signature )
    signature = signer.call( timestamp, payload, secret )

    "t=#{timestamp.to_i},v1=#{signature}"
  end

  def webhook( signature, params )
    # request.env[ 'HTTP_STRIPE_SIGNATURE' ] = signature
    # request.env['RAW_POST_DATA'] = params.to_json # works with Rails 3, 4, or 5
    # post '/shop/stripe_events', body: params.to_json
    # post '/shop/stripe_events',
    post  stripe_event,
          headers: {
            Accept:             'application/json',
            'Content-Type':     'application/json',
            'Stripe-Signature': signature
          },
          params:  params
  end

  def webhook_with_signature( params, secret = secret1 )
    webhook generate_signature( params, secret ), params
  end
end
