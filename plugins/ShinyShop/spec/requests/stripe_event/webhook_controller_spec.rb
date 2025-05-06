# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for stripe
RSpec.describe StripeEvent::WebhookController, type: :request do
  context '' do
    describe '' do
      it '' do
        post '/shop/stripe_events', params: {
          "object": {
            "id": "cs_test_a1EpQUx46ZmXVRrlDCpDTyy7DNsXwDmc3IRH12Bf8KDAm0h35Aeh18IDlG",
            "object": "checkout.session",
          }
        }

        # binding.pry

        expect( response      ).to have_http_status :ok
        expect( response.body ).to include 'No products found'
      end
    end
  end
end
