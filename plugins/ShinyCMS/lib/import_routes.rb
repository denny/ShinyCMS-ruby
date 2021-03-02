# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Import routes from 'partial routes files' into a routes.draw block

module ActionDispatch
  module Routing
    # Monkey patch the route mapper to allow 'route partials'
    class Mapper
      # Pass in the full path to a valid routes partial file, containing
      # one or more route definitions that go inside a routes.draw block
      def import_routes( file:, plugin: 'ShinyCMS' )
        raise ArgumentError, 'File must be specified' if file.blank?

        instance_eval(
          File.read(
            Rails.application.root.join( "plugins/#{plugin}/config/routes/#{file}.rb" )
          )
        )
      end
    end
  end
end
