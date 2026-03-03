# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

sentry_dsn = ENV.fetch( 'SENTRY_DSN', '' )

return if sentry_dsn.blank?

# :nocov:

Sentry.init do |config|
  config.dsn = sentry_dsn
  config.breadcrumbs_logger = [ :active_support_logger ]

  # Set tracesSampleRate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production
  # config.traces_sample_rate = 0.5
  config.traces_sample_rate = 1.0

  # or
  # config.traces_sampler = lambda do |context|
  #   true
  # end
end
