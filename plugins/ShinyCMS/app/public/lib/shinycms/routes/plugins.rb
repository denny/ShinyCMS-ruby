# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Usage; put this inside the .draw block in `routes.rb`:
#   extend ShinyCMS::Routes::Plugins

module ShinyCMS
  module Routes
    # Route extension to mount all the plugin routes
    module Plugins
      def self.extended( router )
        router.instance_exec do
          # Routes from the core plugin
          mount ShinyCMS::Engine, at: '/', as: :shinycms

          # Routes from the feature plugins
          ShinyCMS.plugins.engines.each do |engine|
            mount engine, at: '/'
          end
        end
      end
    end
  end
end
