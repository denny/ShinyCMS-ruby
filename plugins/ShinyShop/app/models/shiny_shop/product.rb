# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Model for shop products
  class Product < ApplicationRecord
    include ShinyCMS::HasPublicName
    include ShinyCMS::HasSlug

    validates :price, numericality: { only_integer: true }

    scope :visible, -> { where( show_on_site: true, active: true ) }

    def create_with_stripe
      return false unless save

      stripe_price = Stripe::Price.create(
        currency:     'gbp',  # TODO: currency handling
        unit_amount:  price,
        product_data: {
          active: active,
          name:   name
        }
      )

      update! stripe_id: stripe_price.product, stripe_price_id: stripe_price.id
    end

    def update_with_stripe( params )
      return false unless update params

      # Price is immutable once created, so just name and active status
      Stripe::Product.update(
        stripe_id, {
          active: active,
          name:   name
        }
      )
      true  # Successful update
    end

    def archive_with_stripe
      Stripe::Product.update( stripe_id, { active: false } )
      update! active: false
    end

    def revive_with_stripe
      Stripe::Product.update( stripe_id, { active: true } )
      update! active: true
    end
  end
end
