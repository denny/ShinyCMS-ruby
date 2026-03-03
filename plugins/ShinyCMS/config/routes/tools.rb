# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Mount engines from gems used by ShinyCMS

# The breadcrumbs component uses this route for its section link
get '/admin/tools/stats', to: Blazer::Engine, as: :blazer

# RailsEmailPreview shows examples of emails that the ShinyCMS mailers can generate
mount RailsEmailPreview::Engine, at: '/admin/tools/rails-email-preview'

# LetterOpener catches all emails sent in development, with a webmail UI to view them
mount LetterOpenerWeb::Engine, at: '/dev/tools/outbox' if Rails.env.development?

# Sidekiq Web provides a web dashboard for Sidekiq jobs and queues
sidekiq_web_enabled = ( ENV['DISABLE_SIDEKIQ_WEB']&.downcase != 'true' )

if sidekiq_web_enabled
  require 'sidekiq/web'
  require 'sidekiq-status/web'

  authenticate :user, ->( user ) { user.can? :use_sidekiq_web, :tools } do
    mount Sidekiq::Web, at: '/admin/tools/sidekiq'
  end
end

# Coverband provides a web UI for viewing code usage information
coverband_web_ui_enabled = ( ENV['DISABLE_COVERBAND_WEB_UI']&.downcase != 'true' )

if coverband_web_ui_enabled
  authenticate :user, ->( user ) { user.can? :use_coverband, :tools } do
    mount Coverband::Reporters::Web.new, at: '/admin/tools/coverband', as: :coverband unless Rails.env.test?
  end
end
