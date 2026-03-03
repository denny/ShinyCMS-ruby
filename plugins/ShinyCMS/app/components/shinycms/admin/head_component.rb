# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    # Component to render the contents of the <head> section in the admin area
    class HeadComponent < ApplicationComponent
      def initialize( page_title:, with_html_editor: false )
        @page_title = page_title

        @load_trix = with_html_editor
      end
    end
  end
end
