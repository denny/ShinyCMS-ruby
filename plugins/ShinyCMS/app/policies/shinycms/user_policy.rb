# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Pundit policy for users
  class UserPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :users
    end

    def search?
      index?
    end

    def username_search?
      search?
    end

    def new?
      @this_user.can? :add, :users
    end

    def create?
      new?
    end

    def edit?
      return @this_user.can? :edit, :admin_users if @record.admin?

      @this_user.can? :edit, :users
    end

    def update?
      edit?
    end

    def destroy?
      return @this_user.can? :destroy, :admin_users if @record.admin?

      @this_user.can? :destroy, :users
    end
  end
end
