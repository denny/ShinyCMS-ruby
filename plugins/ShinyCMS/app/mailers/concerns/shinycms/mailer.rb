# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviour for ShinyCMS mailers - part of the ShinyCMS core plugin
  module Mailer
    extend ActiveSupport::Concern

    # Include this concern or inherit from ShinyCMS::ApplicationMailer to get:
    # * enforcement of the DoNotContact list
    # * enforcement of feature flags, that also implements an overall
    #   on/off switch for all mailers (the :send_emails feature flag)
    # * a helper method for enforcing double opt-in
    # * helper methods to check settings for open/click tracking

    included do
      before_action :check_feature_flags
      before_action :check_do_not_contact

      def enforce_feature_flags( feature_flag_name = nil )
        return if email_feature_flags_enabled?( feature_flag_name )

        # :nocov: TODO: FIXME: WHUT.
        mail.perform_deliveries = false
      end

      def email_feature_flags_enabled?( feature_flag_name )
        return false unless FeatureFlag.enabled? :send_emails

        return true if feature_flag_name.blank?

        FeatureFlag.enabled? feature_flag_name
      end

      def enforce_do_not_contact( email_address )
        mail.perform_deliveries = false if DoNotContact.list_includes? email_address
      end

      def enforce_ok_to_email( recipient )
        # .ok_to_email? checks .confirmed status (AKA double opt-in) and DoNotContact
        mail.perform_deliveries = false unless recipient.ok_to_email?
      end

      def add_to_view_paths( plugin_path )
        # Add plugin view path, if given
        # TODO: Move into ShinyCMS::Plugin ?
        prepend_view_path plugin_path

        # Apply the configured theme, if any, by adding it above the rest
        # TODO: Move into ShinyCMS::Theme ?
        prepend_view_path ShinyCMS::Theme.get&.view_path
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
end
