# frozen_string_literal: true
# This migration comes from shiny_shop (originally 20241202144332)

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class AddStripePriceIdToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :shiny_shop_products, :stripe_price_id, :string

    add_index :shiny_shop_products, :stripe_price_id, unique: true
  end
end
