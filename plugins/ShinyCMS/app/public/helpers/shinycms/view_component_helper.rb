# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Helper method for rendering view components
  module ViewComponentHelper
    def component( name, **args, & )
      # Use this:
      # <%= component 'users/name_with_link', user: comment.author %>
      # To do this:
      # <%= render( ShinyCMS::Users::NameWithLinkComponent.new( user: comment.author ) ) %>

      # If an 'if' param was passed in, exit unless it was true
      return if args.key?( :if ) && !args[:if]

      args.delete( :if )

      render( component_instance( name, **args ), & )
    end

    private

    def component_instance( name, **args )
      component_class( name ).new( **args )
    end

    def component_class( name )
      component_class_name( name ).constantize
    end

    def component_class_name( name )
      classy = name.to_s.camelize

      "ShinyCMS::#{classy}Component"
    end
  end
end
