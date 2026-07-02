# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Pundit policy for access control groups - part of the ShinyAccess plugin for ShinyCMS
  class GroupPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :access_groups
    end

    def search?
      index?
    end

    def new?
      @this_user.can? :add, :access_groups
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :access_groups
    end

    def update?
      edit?
    end

    def destroy?
      @this_user.can? :destroy, :access_groups
    end
  end
end
