# frozen_string_literal: true

# ShinyInserts plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class AddShinyInsertsTables < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_inserts_sets, force: :cascade do |t|
      t.timestamps
    end

    create_table :shiny_inserts_elements, force: :cascade do |t|
      t.string :name, null: false
      t.string :content
      t.string :element_type, default: 'short_text', null: false

      t.belongs_to :set, references: :shiny_inserts_sets, foreign_key: { to_table: :shiny_inserts_sets }, null: false

      t.timestamps

      t.index ["name"], name: :index_insert_elements_on_name, unique: true
    end
  end
end
