# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Inheriting classes must implement check_feature_flags and check_do_not_contact
# - probably by calling enforce_feature_flags() and enforce_do_not_contact()

module ShinyCMS
  # Base class for mailers - part of the ShinyCMS core plugin
  class ApplicationMailer < ActionMailer::Base
    include ShinyCMS::Mailer

    include SiteNameHelper

    helper SiteNameHelper

    default from: -> { default_email }

    track open: -> { track_opens? }, click: -> { track_clicks? }

    layout 'shinycms/layouts/mailer'

    private

    def notified_user( email_address, name = nil )
      User.find_by( email: email_address ) ||
        EmailRecipient.find_by( email: email_address ) ||
        EmailRecipient.create!( email: email_address, name: name )
    end
  end
end
