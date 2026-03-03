# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Helper methods for dealing with Products and Shop Sections
  module MainSiteHelper
    def shop_top_level_menu_items
      ShinyShop::Product.readonly.top_level_menu_items
    end
  end
end
