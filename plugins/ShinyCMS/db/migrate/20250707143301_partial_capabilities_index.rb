# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class PartialCapabilitiesIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :shinycms_user_capabilities, column: [ :user_id, :capability_id ]
    add_index :shinycms_user_capabilities, [ :user_id, :capability_id ], unique: true, where: 'deleted_at is null'
  end
end
