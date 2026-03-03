# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Pundit policy for users
  class ConsentVersionPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :consent_versions
    end

    def search?
      index?
    end

    def show?
      edit?
    end

    def new?
      @this_user.can? :add, :consent_versions
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :consent_versions
    end

    def update?
      edit?
    end

    def destroy?
      @this_user.can? :destroy, :consent_versions
    end
  end
end
