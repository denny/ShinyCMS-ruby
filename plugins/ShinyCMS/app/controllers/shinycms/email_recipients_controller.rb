# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for main site email-recipient features in ShinyCMS
  class EmailRecipientsController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    # Confirm that the person has access to the email account - AKA double opt-in
    def confirm
      recipient = EmailRecipient.find_by( confirm_token: params[ :token ] )

      if recipient&.confirm
        flash[ :notice ] = t( '.success' )
      else
        flash[ :alert ] = t( confirm_failure_message( recipient ) )
      end

      redirect_back_or_to main_app.root_path
    end

    private

    def confirm_failure_message( recipient = nil )
      return '.token_not_found' if recipient.blank?
      return '.token_expired'   if recipient.confirm_expired?

      # '.failure'
    end
  end
end
