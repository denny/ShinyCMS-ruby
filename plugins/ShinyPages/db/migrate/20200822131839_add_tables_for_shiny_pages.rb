# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class AddTablesForShinyPages < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_pages_templates, force: :cascade do |t|
      t.string :name, null: false
      t.text :description
      t.string :filename, null: false

      t.timestamps
    end

    create_table :shiny_pages_template_elements, force: :cascade do |t|
      t.string :name, null: false
      t.string :content
      t.string :element_type, default: 'short_text', null: false
      t.integer :position

      t.belongs_to :template, references: :shiny_pages_templates, foreign_key: { to_table: :shiny_pages_templates }, null: false

      t.timestamps
    end

    create_table :shiny_pages_sections, force: :cascade do |t|
      t.string :internal_name, null: false
      t.string :public_name
      t.string :slug, null: false
      t.text :description
      t.integer :position
      t.boolean :show_in_menus, default: true, null: false
      t.boolean :show_on_site, default: true, null: false

      t.belongs_to :section, references: :shiny_pages_sections, foreign_key: { to_table: :shiny_pages_sections }
      t.bigint :default_page_id

      t.timestamps

      t.index [:section_id, :slug], name: :index_page_sections_on_section_id_and_slug, unique: true
    end

    create_table :shiny_pages_pages, force: :cascade do |t|
      t.string :internal_name, null: false
      t.string :public_name
      t.string :slug, null: false
      t.text :description
      t.integer :position
      t.boolean :show_in_menus, default: true, null: false
      t.boolean :show_on_site, default: true, null: false

      t.belongs_to :section, references: :shiny_pages_sections, foreign_key: { to_table: :shiny_pages_sections }
      t.references :template, references: :shiny_pages_templates, foreign_key: { to_table: :shiny_pages_templates }, null: false

      t.timestamps

      t.index [:section_id, :slug], name: :index_pages_on_section_id_and_slug, unique: true
    end

    create_table :shiny_pages_page_elements, force: :cascade do |t|
      t.string :name, null: false
      t.string :content
      t.string :element_type, default: 'short_text', null: false
      t.integer :position

      t.belongs_to :page, references: :shiny_pages_pages, foreign_key: { to_table: :shiny_pages_pages }, null: false

      t.timestamps
    end

    add_foreign_key :shiny_pages_sections, :shiny_pages_pages, column: :default_page_id
  end
end
