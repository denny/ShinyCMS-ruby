# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class RemoveProductSlugUniqueIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :shop_products, :slug, if_exists: true
  end
end
