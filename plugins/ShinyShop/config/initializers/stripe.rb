# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Initialiser for Stripe integration

require 'stripe'
# require 'stripe_event'  # Moved into top-level routes file for now

Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET']
StripeEvent.configure do |events|
  # Define subscriber behavior based on the event object
  # event.class       # => Stripe::Event
  # event.type        # => "charge.failed"
  # event.data.object # => #<Stripe::Charge:0x3fcb34c115f8>

  events.subscribe 'checkout.session.completed' do |event|
    Rails.logger.info 'StripeEvent received: checkout.session.completed'

    # Send confirmation email to customer
    customer = event.data.object.customer_details
    ShinyShop::ShopMailer.confirmation( customer.email ).deliver_later
  end

  events.all do |event|
    # Handle all event types - logging, etc.
    Rails.logger.info "StripeEvent received: #{event.type}"
  end
end
