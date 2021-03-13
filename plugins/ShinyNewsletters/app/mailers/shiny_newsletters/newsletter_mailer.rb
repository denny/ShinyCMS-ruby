# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Mailer to send a newsletter edition to a list subscriber - part of the ShinyNewsletters plugin for ShinyCMS
  class NewsletterMailer < ShinyCMS::ApplicationMailer
    before_action :stash_subscriber_and_user
    before_action :check_ok_to_email
    before_action :stash_content
    before_action :add_view_path

    layout 'newsletter_mailer'

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

    def add_view_path
      add_to_view_paths 'plugins/ShinyNewsletters/app/views/shiny_newsletters'
    end

    def check_do_not_contact; end  # DNC list is checked in ok_to_email methods
  end
end
