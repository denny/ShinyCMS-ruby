# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Pundit policy for newsletter editions - part of the ShinyNewsletters plugin for ShinyCMS
  class EditionPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :newsletter_editions
    end

    def search?
      index?
    end

    def new?
      @this_user.can? :add, :newsletter_editions
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :newsletter_editions
    end

    def update?
      edit?
    end

    def send_sample?
      @this_user.can? :add, :newsletter_sends
    end

    def destroy?
      @this_user.can? :destroy, :newsletter_editions
    end
  end
end
