# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Mailer for EmailRecipients (non-authenticated site users that we want to send email to)
class EmailRecipientMailer < ApplicationMailer
  # Don't store URLs that might have security tokens in them in email stats data
  track click: false

  # Email a link that the user must click to prove they have access to this email address
  def confirm( recipient )
    @user = @recipient = recipient
    @confirm_token = recipient.confirm_token

    return if DoNotContact.include? recipient.email # TODO: make this happen without explicit call

    mail to: recipient.email_to, subject: t( '.subject', site_name: site_name ) do |format|
      format.html
      format.text
    end
  end
end
