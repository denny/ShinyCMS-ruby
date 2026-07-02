# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class CreateShinyFormsForms < ActiveRecord::Migration[6.0]
  def change
    create_table :shiny_forms_forms do |t|
      t.string :internal_name, null: false
      t.string :public_name
      t.string :slug, null: false
      t.text :description
      t.string :handler, null: false
      t.string :email_to
      t.string :filename
      t.string :redirect_to
      t.string :success_message

      t.timestamps
    end
  end
end
