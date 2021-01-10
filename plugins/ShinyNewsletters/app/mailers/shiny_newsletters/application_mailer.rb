# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Base mailer class - ShinyNewsletters plugin for ShinyCMS
  class ApplicationMailer < ActionMailer::Base
    include ShinyMailerHelper

    helper ShinyMailerHelper

    before_action :set_view_paths

    track open: -> { track_opens? }, click: -> { track_clicks? }

    default from: -> { default_email }

    layout 'newsletter_mailer'

    private

    def set_view_paths
      add_view_paths 'plugins/ShinyNewsletters/app/views'
    end
  end
end
