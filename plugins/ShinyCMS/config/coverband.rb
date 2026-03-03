# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Coverband config

# Pulled into main_app by /config/coverband.rb

return if Rails.env.test?

# :nocov:

Coverband.configure do |config|
  config.track_views = true
  config.store = Coverband::Adapters::RedisStore.new(
    Redis.new(
      url:        ENV['REDIS_URL'],
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
    )
  )
end
