# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This catch-all route matches anything and everything not already matched by a route
# defined before it. It enables the ShinyPages plugin to create pages and sections at
# the top level of the site - i.e. /foo instead of /pages/foo

# See ShinyHostApp config/routes.rb for how to import this route from this file

# Because this route matches anything that reaches it, it must be defined last!

get '*path', to: 'shiny_pages/pages#show', constraints: lambda { |request|
  !request.path.starts_with?( '/rails/active_' )
}
