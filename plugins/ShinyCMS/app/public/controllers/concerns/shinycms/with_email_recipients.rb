# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Allow controllers in other plugins to access some EmailRecipient data
  module WithEmailRecipients
    extend ActiveSupport::Concern

    included do
      def confirmed_email_recipients
        EmailRecipient.readonly.confirmed
      end

      def email_recipient_with_token( token )
        ShinyCMS::EmailRecipient.find_by( token: token )
      end

      def email_recipient_with_email( address )
        ShinyCMS::EmailRecipient.find_by( email: address )
      end

      def create_email_recipient( email_address )
        ShinyCMS::EmailRecipient.create!( email: email_address )
      end
    end
  end
end
