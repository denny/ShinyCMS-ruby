# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Routes file partial to mount engines from other gems used by ShinyCMS,
# that can be mounted within the core plugin routes file

# CKEditor provides the WYSIWYG editor used in the ShinyCMS admin area
mount Ckeditor::Engine, at: '/admin/tools/ckeditor'

# LetterOpener catches all emails sent in development, with a webmail UI to view them
mount LetterOpenerWeb::Engine, at: '/dev/tools/outbox' if Rails.env.development?

# Sidekiq Web provides a web dashboard for Sidekiq jobs and queues
def sidekiq_web_enabled?
  ENV['DISABLE_SIDEKIQ_WEB']&.downcase != 'true'
end

if sidekiq_web_enabled?
  require 'sidekiq/web'
  require 'sidekiq-status/web'

  Sidekiq::Web.set :sessions, false

  authenticate :user, ->( user ) { user.can? :manage_sidekiq_jobs } do
    mount Sidekiq::Web, at: '/admin/tools/sidekiq'
  end
end

# Coverband provides a web UI for viewing code usage information
def coverband_web_ui_enabled?
  ENV['DISABLE_COVERBAND_WEB_UI']&.downcase != 'true'
end

if coverband_web_ui_enabled?
  authenticate :user, ->( user ) { user.can? :view_code_usage } do
    mount Coverband::Reporters::Web.new, at: '/admin/tools/coverband', as: :coverband unless Rails.env.test?
  end
end
