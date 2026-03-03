# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# The ShinyCMS route delegator is a mildly complicated routing bodge which
# helps ShinyCMS embed non-ShinyCMS engines into the ShinyCMS admin area,
# even if they weren't designed with that sort of embedded usage in mind.
#
# The idea was copied from RailsEmailPreview, which has this feature built-in.
# (Which made REP much easier to integrate with ShinyCMS - thank you!)

module ShinyCMS
  # Rescue calls to 'missing' ShinyCMS route helpers coming from inside other engines
  module RouteDelegator
    def method_missing( method, *args, & )
      if main_app_route_method?( method )
        main_app.__send__( method, *args )
      else
        super
      end
    end

    def respond_to_missing?( method )
      # :nocov:
      super || main_app_route_method?( method )
      # :nocov:
    end

    private

    def main_app_route_method?( method )
      method.to_s =~ /_(?:path|url)$/ && main_app.respond_to?( method )
    end
  end
end
