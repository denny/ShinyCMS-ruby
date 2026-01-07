# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This catch-all route matches anything and everything not already matched by a route
# defined before it. It enables the ShinyPages plugin to create pages and sections at
# the top level of the site - i.e. /foo instead of /pages/foo

# Usage; put this inside the .draw block in `/config/routes.rb`:
#   extend ShinyPages::Routes::TopLevelPages

# NB: Because this route matches EVERYTHING that reaches it, it must be defined last!

module ShinyPages
  module Routes
    # Route extender that sets ShinyPages to handle all top-level pages
    module TopLevelPages
      def self.extended( router )
        router.instance_exec do
          scope format: false do
            get '*path', to: 'shiny_pages/pages#show', constraints: lambda { |request|
              !request.path.starts_with?( '/rails/active_' )
            }
          end
        end
      end
    end
  end
end
