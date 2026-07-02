# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Pundit policy for mailing lists - part of the ShinyLists plugin for ShinyCMS
  class ListPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :mailing_lists
    end

    def search?
      index?
    end

    def new?
      @this_user.can? :add, :mailing_lists
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :mailing_lists
    end

    def update?
      edit?
    end

    def destroy?
      @this_user.can? :destroy, :mailing_lists
    end
  end
end
