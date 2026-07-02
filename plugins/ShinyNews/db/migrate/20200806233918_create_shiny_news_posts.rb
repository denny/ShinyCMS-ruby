# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class CreateShinyNewsPosts < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_news_posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :body
      t.boolean :show_on_site, null: false, default: true

      t.belongs_to :user, foreign_key: true, null: false

      t.timestamp :posted_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamps
    end
  end
end
