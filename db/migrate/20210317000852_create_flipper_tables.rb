# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class CreateFlipperTables < ActiveRecord::Migration[6.1]
  def change
    create_table :flipper_features do |t|
      t.text :key, null: false

      t.timestamps
    end

    create_table :flipper_gates do |t|
      t.text :feature_key, null: false
      t.text :key,         null: false
      t.text :value

      t.timestamps
    end
  end
end
