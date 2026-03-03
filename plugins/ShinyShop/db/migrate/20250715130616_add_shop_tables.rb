# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class AddShopTables < ActiveRecord::Migration[8.0]
  def change
    create_table :shiny_shop_templates, force: :cascade do |t|
      t.string :name, null: false
      t.text :description
      t.string :filename, null: false

      t.timestamps
    end

    create_table :shiny_shop_template_elements, force: :cascade do |t|
      t.string :name, null: false
      t.string :content
      t.string :element_type, default: 'short_text', null: false
      t.integer :position

      t.belongs_to :template, foreign_key: { to_table: :shiny_shop_templates }, null: false

      t.timestamps
    end

    create_table :shiny_shop_sections, force: :cascade do |t|
      t.string :internal_name, null: false
      t.string :public_name
      t.string :slug, null: false
      t.text :description
      t.integer :position
      t.boolean :show_in_menus, default: true, null: false
      t.boolean :show_on_site, default: true, null: false

      t.belongs_to :section, foreign_key: { to_table: :shiny_shop_sections }

      t.timestamps

      t.index [:section_id, :slug], name: :index_shop_sections_on_section_id_and_slug, unique: true
    end

    change_table :shiny_shop_products, force: :cascade do |t|
      t.boolean :show_in_menus, default: true, null: false

      t.belongs_to :section, foreign_key: { to_table: :shiny_shop_sections }
      t.belongs_to :template, foreign_key: { to_table: :shiny_shop_templates }

      t.index [:section_id, :slug], name: :index_products_on_section_id_and_slug, unique: true
    end

    create_table :shiny_shop_product_elements, force: :cascade do |t|
      t.string :name, null: false
      t.string :content
      t.string :element_type, default: 'short_text', null: false
      t.integer :position

      t.belongs_to :product, foreign_key: { to_table: :shiny_shop_products }, null: false

      t.timestamps
    end
  end
end
