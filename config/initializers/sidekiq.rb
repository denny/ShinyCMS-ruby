# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Configure Redis for Sidekiq

redis_options = { url: ENV['REDIS_URL'] }

redis_options[:ssl_params] = { verify_mode: OpenSSL::SSL::VERIFY_NONE } if ENV['REDIS_VERIFY_MODE'] == 'none'

Sidekiq.configure_server do |config|
  config.redis = redis_options
end

Sidekiq.configure_client do |config|
  config.redis = redis_options
end
