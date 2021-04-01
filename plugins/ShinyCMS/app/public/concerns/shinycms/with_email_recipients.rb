# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Allow controllers in other plugins to access some EmailRecipient data
  module WithEmailRecipients
    extend ActiveSupport::Concern

    included do
      def confirmed_email_recipients
        EnailRecipient.readonly.confirmed
      end
    end
  end
end
