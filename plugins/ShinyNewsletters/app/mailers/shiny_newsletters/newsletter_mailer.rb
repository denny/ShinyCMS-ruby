# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Mailer to send a newsletter edition to a list subscriber - part of the ShinyNewsletters plugin for ShinyCMS
  class NewsletterMailer < ApplicationMailer
    before_action :stash_subscriber_and_user
    before_action :stash_content

    layout 'shiny_newsletters/layouts/newsletter_mailer'

    def send_email
      mail to: @subscriber.email_to, subject: @edition.subject, template_name: @edition.template.filename do |format|
        format.html
        format.text
      end
    end

    private

    def check_feature_flags
      enforce_feature_flags :newsletters
    end

    def stash_subscriber_and_user
      @subscriber = @user = params[:subscriber]
    end

    def check_ok_to_email
      enforce_ok_to_email @subscriber
    end

    def stash_content
      @edition  = params[:edition]

      @elements = @edition.elements_hash
    end
  end
end
