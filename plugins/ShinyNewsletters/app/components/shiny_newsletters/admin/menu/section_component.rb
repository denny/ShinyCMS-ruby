# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  module Admin
    module Menu
      # Component to render Newsletters section in admin menu
      class SectionComponent < ApplicationComponent
        def initialize( current_user: )
          @current_user = current_user
        end
      end
    end
  end
end
