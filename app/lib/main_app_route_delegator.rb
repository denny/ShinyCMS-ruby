# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Load ShinyCMS routes inside uncooperative engines - e.g. Blazer
# (Inspired by RailsEmailPreview, which has this feature built in)
module MainAppRouteDelegator
  def method_missing( method, *args, &block )
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
