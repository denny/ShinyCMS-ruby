# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    module Head
      # Component to render <title> in <head> in admin area
      class TitleComponent < ApplicationComponent
        def initialize( page_title: nil, branding: nil, separator: ' - ' )
          @title = [ page_title, branding, 'ShinyCMS' ].compact.join( separator )
        end

        def call
          tag.title @title
        end
      end
    end
  end
end
