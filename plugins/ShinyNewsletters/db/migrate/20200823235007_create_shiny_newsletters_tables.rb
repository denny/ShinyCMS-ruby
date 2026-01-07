# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class CreateShinyNewslettersTables < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_newsletters_templates do |t|
      t.string :name, null: false
      t.text :description
      t.string :filename, null: false

      t.timestamps
    end

    create_table :shiny_newsletters_template_elements do |t|
      t.string :name, null: false
      t.string :content
      t.string :element_type, null: false, default: 'short_text'
      t.integer :position

      t.belongs_to :template, references: :shiny_newsletters_templates, foreign_key: { to_table: :shiny_newsletters_templates }, null: false

      t.timestamps
    end

    create_table :shiny_newsletters_editions do |t|
      t.string :internal_name, null: false
      t.string :public_name
      t.string :slug, null: false
      t.text :description

      t.string :from_name
      t.string :from_email
      t.string :subject

      t.boolean :show_on_site, null: false, default: true

      t.references :template, references: :shiny_newsletters_templates, foreign_key: { to_table: :shiny_newsletters_templates }, null: false

      t.timestamp :published_at
      t.timestamps
    end

    create_table :shiny_newsletters_edition_elements do |t|
      t.string :name, null: false
      t.string :content
      t.string :element_type, null: false, default: 'short_text'
      t.integer :position

      t.belongs_to :edition, references: :shiny_newsletters_editions, foreign_key: { to_table: :shiny_newsletters_editions }, null: false

      t.timestamps
    end

    create_table :shiny_newsletters_sends do |t|
      t.references :edition, references: :shiny_newsletters_editions, foreign_key: { to_table: :shiny_newsletters_editions }, null: false
      t.references :list, references: :shiny_lists_lists, foreign_key: { to_table: :shiny_lists_lists }, null: false

      t.timestamp :send_at
      t.timestamp :started_sending_at
      t.timestamp :finished_sending_at
      t.timestamps
    end
  end
end
