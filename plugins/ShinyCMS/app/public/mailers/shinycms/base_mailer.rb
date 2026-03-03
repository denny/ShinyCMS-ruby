# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Plugin mailers can inherit from here to get some CMS integration and common behaviours.
#
# Mailers that inherit from here will need to override the implementations of `check_feature_flags`
# and `check_ok_to_email`. The `enforce_feature_flags` method is provided to help with the first,
# and the `enforce_ok_to_email` (or `enforce_do_not_contact`) method to help with the second.

module ShinyCMS
  # Public base class for mailers - part of the ShinyCMS core plugin
  class BaseMailer < SetupForBaseMailer
    # :nocov:
    def check_feature_flags
      stop!
    end

    def check_ok_to_email
      stop!
    end
    # :nocov:

    private

    def enforce_feature_flags( *feature_flag_names )
      stop! unless feature_flags_enabled? feature_flag_names
      # Calling feature_flags_enabled? in a Mailer will always check the site-wide
      # 'send_emails' flag, as well as whatever specific feature flags you pass it
    end

    def enforce_ok_to_email( email_recipient )
      stop! if email_recipient.blank?
      # HasEmail.not_ok_to_email? checks .confirmed status (AKA double opt-in)
      # and whether the address is listed as DoNotContact
      stop! if email_recipient.not_ok_to_email?
    end

    def enforce_do_not_contact( email_address )
      # You should use `enforce_ok_to_email` rather than this method whenever possible.
      # The only exception is for mailer actions where checking the .confirmed status
      # is impossible or would make no sense (e.g. when sending the confirmation email!)
      stop! if DoNotContact.listed? email_address
    end
  end
end
