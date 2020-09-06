# frozen_string_literal: true
# This migration comes from shiny_lists (originally 20200823014211)

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class AddShinyListsTables < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_lists_lists do |t|
      t.string :internal_name, null: false
      t.string :public_name
      t.string :slug, null: false
      t.text :description

      t.timestamps
    end

    create_table :shiny_lists_subscriptions do |t|
      t.references :list
      t.references :subscriber, polymorphic: true, index: { name: 'shiny_lists_subscriptions_on_subscribers' }
      t.references :consent_version

      t.timestamp :subscribed_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :unsubscribed_at
      t.timestamps
    end
  end
end
