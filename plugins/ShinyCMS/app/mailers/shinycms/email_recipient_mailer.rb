# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Mailer for EmailRecipients (non-authenticated site users that we want to send email to)
  class EmailRecipientMailer < ApplicationMailer
    # Don't store URLs that might have security tokens in them in email stats data
    track click: false

    # Email a link that the user must click to prove they have access to this email address
    def confirm( recipient )
      return if not_ok_to_email? recipient

      stash_instance_vars( recipient )

      mail to: recipient.email_to, subject: confirm_subject do |format|
        format.html
        format.text
      end
    end

    private

    def not_ok_to_email?( recipient )
      DoNotContact.list_includes? recipient.email
    end

    def stash_instance_vars( recipient )
      @recipient = @user = recipient

      @confirm_token = recipient.confirm_token
    end

    def confirm_subject
      t( 'shinycms.email_recipient_mailer.confirm.subject', site_name: site_name )
    end
  end
end
