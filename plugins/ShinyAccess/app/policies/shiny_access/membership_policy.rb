# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Pundit policy for access control group memberships - part of the ShinyAccess plugin for ShinyCMS
  class MembershipPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :access_group_memberships
    end

    def search?
      index?
    end

    def create?
      @this_user.can? :add, :access_group_memberships
    end

    def destroy?
      @this_user.can? :destroy, :access_group_memberships
    end
  end
end
