# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Usage; put this inside the .draw block in `/config/routes.rb`:
#   extend ShinyPages::Routes::RootPage

module ShinyPages
  module Routes
    # Route extension that sets ShinyPages to handle the root route (the main site homepage)
    module RootPage
      def self.extended( router )
        router.instance_exec do
          scope format: false do
            root to: 'shiny_pages/pages#index'
          end
        end
      end
    end
  end
end
