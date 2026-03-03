# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  module Admin
    module Menu
      # Component to render admin menu section
      class SectionComponent < ApplicationComponent
        def initialize( text:, icon:, is_open: false )
          @text = text
          @icon = icon

          @anchor = text.parameterize

          @is_open = is_open
        end
      end
    end
  end
end
