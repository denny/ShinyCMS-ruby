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
    include ShinyMailerHelper

    before_action :set_view_paths
    before_action :set_site_name

    track open: -> { track_opens? }, click: -> { track_clicks? }

    default from: -> { default_email }

    layout 'mailer'

    private

    def set_view_paths
      add_view_paths 'plugins/ShinyNewsletters/app/views'
    end

    def set_site_name
      @site_name = site_name
    end
  end
end
