# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Mailer to send a newsletter edition to a list subscriber - ShinyNewsletters plugin for ShinyCMS
  class NewsletterMailer < ApplicationMailer
    before_action :check_feature_flags

    def send_email( edition, subscriber )
      @edition  = edition
      @elements = edition.elements_hash
      @user     = subscriber

      mail to: @user.email_to, subject: edition.subject, template_name: edition.template.filename do |format|
        format.html
        format.text
      end
    end

    private

    def check_feature_flags
      enforce_feature_flags :newsletters
    end
  end
end
