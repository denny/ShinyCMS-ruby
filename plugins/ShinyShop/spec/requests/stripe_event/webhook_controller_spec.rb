# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for stripe
RSpec.describe StripeEvent::WebhookController, type: :request do
  let( :secret1 ) { ENV.fetch( 'STRIPE_SIGNING_SECRET' ) }

  describe 'with Stripe::Event' do
    it 'queues a mailer job' do
      expect { send_checkout_session_completed_event }.to have_enqueued_job

      expect( response ).to have_http_status :ok
    end
  end

  def send_checkout_session_completed_event
    webhook_with_signature(
      data: {
        object: {
          customer_details: {
            email: 'SPAMTRAP@shinycms.org'
          }
        }
      },
      type: 'checkout.session.completed'
    )
  end

  def generate_signature( params, secret )
    payload   = params.to_json
    timestamp = Time.now.utc

    signature = Stripe::Webhook::Signature.compute_signature( timestamp, payload, secret )

    Stripe::Webhook::Signature.generate_header( timestamp, signature )
  end

  def webhook( signature, params )
    post  stripe_event_path,
          headers: {
            Accept:             'application/json',
            'Content-Type':     'application/json',
            'Stripe-Signature': signature
          },
          params:  params.to_json
  end

  def webhook_with_signature( params, secret = secret1 )
    webhook generate_signature( params, secret ), params
  end
end
