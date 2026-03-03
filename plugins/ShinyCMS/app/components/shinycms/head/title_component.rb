# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Head
    # Component to render <title> in <head> on main site
    class TitleComponent < ApplicationComponent
      # def initialize( prefix: nil, page_title: nil, middle: nil, site_name: nil, suffix: nil, separator: ' - ' )
      #   @title = [ prefix, page_title, middle, site_name, suffix ].compact.join( separator )
      # end

      def initialize( prefix: nil, page_title: nil, site_name: 'MyShinySite', suffix: nil, separator: ' - ' )
        @title = [ prefix, page_title, site_name, suffix ].compact.join( separator )
      end

      def call
        tag.title @title
      end
    end
  end
end
