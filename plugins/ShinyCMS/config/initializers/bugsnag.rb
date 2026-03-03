# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

bugsnag_api_key = ENV.fetch( 'BUGSNAG_API_KEY', '' )

return if bugsnag_api_key.blank?

# :nocov:

Bugsnag.configure do |config|
  config.api_key = bugsnag_api_key
  config.discard_classes << 'ActiveRecord::RecordNotFound'
end
