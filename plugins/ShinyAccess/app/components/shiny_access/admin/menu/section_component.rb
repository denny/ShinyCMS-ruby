# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  module Admin
    module Menu
      # Component to render Access section in admin menu
      class SectionComponent < ApplicationComponent
        def initialize( current_user: )
          @current_user = current_user
        end
      end
    end
  end
end
