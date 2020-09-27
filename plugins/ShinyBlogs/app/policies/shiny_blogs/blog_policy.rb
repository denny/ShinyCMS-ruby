# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlogs
  # Pundit policy for blogs - part of the ShinyBlogs plugin for ShinyCMS
  class BlogPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :blogs
    end

    def new?
      @this_user.can? :add, :blogs
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :blogs
    end

    def update?
      edit?
    end

    def destroy?
      @this_user.can? :destroy, :blogs
    end
  end
end
