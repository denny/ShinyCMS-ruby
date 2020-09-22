# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Base mailer class - ShinyNewsletters plugin for ShinyCMS
  class ApplicationMailer < ActionMailer::Base
    include FeatureFlagsHelper

    before_action :set_view_paths
    before_action :set_site_name

    default from: -> { default_email }

    track open: -> { track_opens? }, click: -> { track_clicks? }

    layout 'mailer'

    private

    def set_view_paths
      # Add the default templates directory to the top of view_paths
      prepend_view_path 'app/views/shinycms'
      # Add the default templates directory for this plugin above that
      prepend_view_path 'plugins/ShinyNewsletters/app/views/shiny_newsletters'
      # Apply the configured theme, if any, by adding it above the defaults
      prepend_view_path ::Theme.current.view_path if ::Theme.current
    end

    def set_site_name
      @site_name = I18n.t( 'site_name' )
    end

    def default_email
      ::Setting.get( :default_email ) || ENV[ 'DEFAULT_EMAIL' ]
    end

    # FIXME
    # :nocov:
    def track_opens?
      Setting.get( :track_opens )&.downcase == 'yes'
    end

    def track_clicks?
      Setting.get( :track_clicks )&.downcase == 'yes'
    end
    # :nocov:
  end
end
