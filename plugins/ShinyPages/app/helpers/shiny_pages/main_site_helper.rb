# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Helper methods for dealing with Pages and Page Sections
  module MainSiteHelper
    def default_page
      ShinyPages::Page.readonly.default_page
    end

    def top_level_menu_items
      ShinyPages::Page.readonly.top_level_menu_items
    end

    def find_top_level_page( slug )
      top_level_pages&.find_by( slug: slug )
    end

    def find_top_level_section( slug )
      top_level_sections&.find_by( slug: slug )
    end

    def top_level_pages
      ShinyPages::Page.readonly.top_level_pages
    end

    def top_level_sections
      ShinyPages::Section.readonly.top_level_sections
    end
  end
end
