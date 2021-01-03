# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_email_preview'

RailsEmailPreview.setup do |config|
  # Hook before rendering preview:
  # config.before_render do |message, preview_class_name, mailer_action|
  #  # Use roadie-rails:
  #  Roadie::Rails::MailInliner.new(message, message.roadie_options).execute
  #  # Use premailer-rails:
  #  Premailer::Rails::Hook.delivering_email(message)
  #  # Use actionmailer-inline-css:
  #  ActionMailer::InlineCssHook.delivering_email(message)
  # end

  # Show/hide Send Email button
  config.enable_send_email = true

  # You can specify a controller for RailsEmailPreview::ApplicationController
  # to inherit from (default: '::ApplicationController'):
  # config.parent_controller = 'Admin::ApplicationController'
  config.parent_controller = 'Admin::EmailPreviewsController'
end

# Enable Comfortable Mexican Sofa integration:
# require 'rails_email_preview/integrations/comfortable_mexica_sofa'

Rails.application.config.to_prepare do
  # Render REP inside a custom layout
  # (set to 'application' to use app layout, default is REP's own layout)
  # This will also make application routes accessible from within REP:
  RailsEmailPreview.layout = 'admin/layouts/admin_area'

  # Set UI locale to something other than :en
  # RailsEmailPreview.locale = :de

  # Auto-load preview classes from:
  RailsEmailPreview.preview_classes =
    RailsEmailPreview.find_preview_classes( 'app/mailer_previews' )
end
