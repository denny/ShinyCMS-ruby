# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

Rack::Attack.blocklisted_responder =
  lambda do |_|
    # Using 204 to prevent bots filling up logging with meaningless errors
    # Rack::Attack returns 403 for blocklists by default
    [ 204, {}, [ 'No Content' ] ]
  end

Rack::Attack.blocklist( 'block common Wordpress and other PHP URLs' ) do |request|
  # Requests are blocked if the return value is truthy
  request.path.start_with?( '/wp-admin', '/wp-login', '/wp-content', '/wp-includes' )
end
