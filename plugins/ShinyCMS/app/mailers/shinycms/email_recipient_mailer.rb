# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Mailer for EmailRecipients (non-authenticated site users that we want to send email to)
  class EmailRecipientMailer < BaseMailer
    before_action :stash_recipient_and_user
    before_action :stash_confirm_token

    # Don't store URLs that might have security tokens in them in email stats data
    track click: false

    # Email a link that the user must click to prove they have access to this email address
    def confirm
      mail to: @recipient.email_to, subject: confirm_subject do |format|
        format.html
        format.text
      end
    end

    private

    def check_feature_flags
      enforce_feature_flags
    end

    def stash_recipient_and_user
      @recipient = @user = params[:recipient]
    end

    def check_ok_to_email
      enforce_do_not_contact @recipient.email
    end

    def stash_confirm_token
      @confirm_token = @recipient.confirm_token
    end

    def confirm_subject
      t( 'shinycms.email_recipient_mailer.confirm.subject', site_name: site_name )
    end
  end
end
