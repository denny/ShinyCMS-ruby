# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Mailers that inherit from here must implement `check_feature_flags` (probably using `enforce_feature_flags`)
# and `check_ok_to_email` (probably using either `enforce_ok_to_email` or `enforce_do_not_contact`).

module ShinyCMS
  # Base class for mailers - part of the ShinyCMS core plugin
  class ApplicationMailer < ActionMailer::Base
    include SiteNameHelper

    helper SiteNameHelper

    before_action :check_feature_flags
    after_action :check_ok_to_email

    default from: -> { default_email }

    track open: -> { track_opens? }, click: -> { track_clicks? }

    layout 'shinycms/layouts/mailer'

    private

    def enforce_feature_flags( *feature_flag_names )
      mail.perform_deliveries = false unless feature_flags_enabled?( feature_flag_names )
    end

    def enforce_ok_to_email( recipient )
      # .ok_to_email? checks .confirmed status (AKA double opt-in) and DoNotContact status
      mail.perform_deliveries = false unless recipient&.ok_to_email?
    end

    def enforce_do_not_contact( email_address )
      # For the rare cases when you don't want to check .confirmed status (e.g. confirmation emails)
      mail.perform_deliveries = false if DoNotContact.list_includes? email_address
    end

    def feature_flags_enabled?( *feature_flag_names )
      ( [ :send_emails ] + [ feature_flag_names ] ).flatten.all? { |name| FeatureFlag.enabled? name }
    end

    def add_to_view_paths( plugin_path )
      # Add plugin view path, if given
      # TODO: Move into ShinyCMS::Plugin ?
      prepend_view_path plugin_path

      # Apply the configured theme, if any, by adding it above the rest
      # TODO: Move into ShinyCMS::Theme ?
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
