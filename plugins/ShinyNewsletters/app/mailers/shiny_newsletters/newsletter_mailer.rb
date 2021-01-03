# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Mailer to send a newsletter edition to a list subscriber - ShinyNewsletters plugin for ShinyCMS
  class NewsletterMailer < ApplicationMailer
    before_action :check_feature_flags

    def send_email( edition, recipient )
      stash_content( edition )
      stash_user( recipient )

      return if @user.do_not_email? # TODO: make this happen without explicit call

      mail to: @user.email_to, subject: @edition.subject, template_name: @edition.template.filename do |format|
        format.html
        format.text
      end
    end

    private

    def stash_content( edition )
      @edition  = edition
      @elements = edition.elements_hash
    end

    def stash_user( recipient )
      @user = recipient
    end

    def check_feature_flags
      enforce_feature_flags :newsletters
    end
  end
end
