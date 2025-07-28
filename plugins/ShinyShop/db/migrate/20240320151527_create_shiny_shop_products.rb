# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class CreateShinyShopProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :shiny_shop_products, force: :cascade do |t|
      t.string :internal_name, null: false
      t.string :public_name
      t.string :slug, null: false, index: { unique: true }
      t.text :description
      t.integer :position
      t.boolean :show_on_site, default: true, null: false

      t.timestamps
    end
  end
end
