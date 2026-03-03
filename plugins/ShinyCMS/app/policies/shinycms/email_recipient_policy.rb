# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Pundit policy for email recipients
  # (people that we send email to, who don't have a user account - comment notifications, list subscribers, etc)
  class EmailRecipientPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :email_recipients
    end

    def search?
      index?
    end

    def do_not_contact?
      destroy?
    end

    def destroy?
      @this_user.can? :destroy, :email_recipients
    end
  end
end
