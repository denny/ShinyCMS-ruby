# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Mailers that inherit from here must implement `check_feature_flags` (probably
# using `enforce_feature_flags`) and `check_ok_to_email` (probably using either
# `enforce_ok_to_email` or `enforce_do_not_contact`)

module ShinyCMS
  # Base class for mailers - part of the ShinyCMS core plugin
  class ApplicationMailer < ActionMailer::Base
    include SiteNameHelper

    helper SiteNameHelper

    before_action :check_feature_flags
    before_action :add_theme_view_path

    after_action :check_ok_to_email

    default from: -> { default_email }

    track open: -> { track_opens? }, click: -> { track_clicks? }

    layout 'shinycms/layouts/mailer'

    private

    def stop!
      mail.perform_deliveries = false
      # Stop processing, now. See https://is.gd/ActionMailerStop (and last line of https://is.gd/ActionMailerCallbacks)
      self.response_body = nil
    end

    def enforce_feature_flags( *feature_flag_names )
      stop! unless feature_flags_enabled? feature_flag_names
    end

    def enforce_ok_to_email( email_recipient )
      stop! if email_recipient.blank?
      # HasEmail.not_ok_to_email? checks on .confirmed status
      # (AKA double opt-in) and DoNotContact status
      stop! if email_recipient.not_ok_to_email?
    end

    def enforce_do_not_contact( email_address )
      # You should use `enforce_ok_to_email` rather than this method whenever possible.
      # The only exception is for mailer actions where checking the .confirmed status
      # is impossible or would make no sense (e.g. when sending the confirmation email!)
      stop! if DoNotContact.list_includes? email_address
    end

    def feature_flags_enabled?( *feature_flag_names )
      ( [ :send_emails ] + [ feature_flag_names ] ).flatten.all? { |name| FeatureFlag.enabled? name }
    end

    def add_theme_view_path
      # Apply the configured theme, if any, by adding it at top of view paths
      theme = ShinyCMS::Theme.get
      prepend_view_path theme.view_path if theme.present?
    end

    def notified_user( email_address, name = nil )
      User.find_by( email: email_address ) ||
        EmailRecipient.find_by( email: email_address ) ||
        EmailRecipient.create!( email: email_address, name: name )
    end

    def default_email
      ShinyCMS::Setting.get( :default_email ) || ENV[ 'DEFAULT_EMAIL' ]
    end

    def track_opens?
      ShinyCMS::Setting.true?( :track_opens )
    end

    def track_clicks?
      ShinyCMS::Setting.true?( :track_clicks )
    end
  end
end
