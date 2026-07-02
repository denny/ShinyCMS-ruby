# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Pundit policy for mailing lists - part of the ShinyLists plugin for ShinyCMS
  class SubscriptionPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :mailing_list_subscriptions
    end

    def search?
      index?
    end

    def create?
      @this_user.can? :add, :mailing_list_subscriptions
    end

    def destroy?
      @this_user.can? :destroy, :mailing_list_subscriptions
    end
  end
end
