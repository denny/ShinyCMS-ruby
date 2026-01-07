# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Pundit policy for newsletter sends - part of the ShinyNewsletters plugin for ShinyCMS
  class SendPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :newsletter_sends
    end

    def search?
      index?
    end

    def sent?
      index?
    end

    def show?
      edit?
    end

    def new?
      @this_user.can? :add, :newsletter_sends
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :newsletter_sends
    end

    def update?
      edit?
    end

    def start_sending?
      create?
    end

    def cancel_sending?
      edit?
    end

    def destroy?
      @this_user.can? :destroy, :newsletter_sends
    end
  end
end
