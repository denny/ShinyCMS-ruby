# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# :nocov: - until I can get the tests past square zero

Flipper.configure do |config|
  config.default do
    adapter = Flipper::Adapters::ActiveRecord.new
    Flipper.new( adapter )
  end
end

# Rails.configuration.middleware.use Flipper::Middleware::Memoizer, preload_all: true

# Embed Flipper in the ShinyCMS admin UI
Rails.application.config.to_prepare do
  # Flipper::BaseController.prepend_view_path 'plugins/ShinyCMS/app/views/shinycms'
  # Flipper::BaseController.layout 'admin/layouts/admin_area'
  # # Inject our standard IP allow-list check (if configured)
  # Flipper::BaseController.before_action :enforce_allowed_ips
end
