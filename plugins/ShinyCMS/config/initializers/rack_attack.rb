# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

Rack::Attack.blocklisted_responder =
  lambda do |_|
    # Using 204 to prevent bots filling up logging with meaningless errors
    # Rack::Attack returns 403 for blocklists by default
    [ 204, {}, [ 'No Content' ] ]
  end

# Requests are blocked if the return value is truthy
Rack::Attack.blocklist( 'stop requests for PHP and common Wordpress URLs' ) do |request|
  request.path.include?(    '/wp-includes' ) ||
    request.path.include?(  '/wp-content'  ) ||
    request.path.include?(  '/wp-admin'    ) ||
    request.path.end_with?( '.php' )
end
