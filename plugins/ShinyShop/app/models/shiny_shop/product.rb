# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Model for shop products
  class Product < ApplicationRecord
    include ShinyCMS::CanHide
    include ShinyCMS::HasPublicName
    include ShinyCMS::HasReadableName
    include ShinyCMS::HasSlug

    include ShinyCMS::ProvidesDemoSiteData

    belongs_to :section,  inverse_of: :all_products, optional: true
    belongs_to :template, inverse_of: :products

    has_many :elements, -> { order( :position ).includes( [ :image_attachment ] ) },
             inverse_of: :product, dependent: :destroy, class_name: 'ProductElement'

    accepts_nested_attributes_for :elements, allow_destroy: true

    validates :price, numericality: { only_integer: true }

    # Scopes and sorting

    scope :visible,          -> { where( show_on_site: true, active: true ) }
    scope :visible_in_menus, -> { where( show_on_site: true, active: true, show_in_menus: true ) }

    scope :top_level, -> { where( section: nil ) }

    acts_as_list scope: :section
    self.implicit_order_column = 'position'

    # Instance methods

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

    # Class methods

    def self.all_top_level_products
      top_level
    end

    def self.top_level_products
      top_level.visible
    end

    def self.all_top_level_items
      products = all_top_level_products.to_a
      sections = Section.includes( %i[ all_products all_sections ] ).all_top_level_sections.to_a

      [ *products, *sections ].sort_by do |item|
        [ item.position ? 0 : 1, item.position || 0 ]
      end
    end
  end
end
