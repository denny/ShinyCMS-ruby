# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Model for shop products
  class Product < ApplicationRecord
    include ShinyCMS::HasPublicName
    include ShinyCMS::HasSlug

    def save_with_stripe
      save!

      stripe_price = Stripe::Price.create(
        currency:     'gbp',
        unit_amount:  price,
        product_data: { name: public_name }
      )

      update! stripe_id: stripe_price.product
    end

    def archive_with_stripe
      Stripe::Product.update( stripe_id, { active: false } )
      update! active: false
    end
  end
end
