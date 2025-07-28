# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class AddPriceToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :shiny_shop_products, :price, :integer
  end
end
