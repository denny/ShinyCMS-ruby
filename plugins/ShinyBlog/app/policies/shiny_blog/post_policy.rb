# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlog
  # Pundit policy for blog posts - part of the ShinyBlog plugin for ShinyCMS
  class PostPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :blog_posts
    end

    def search?
      index?
    end

    def new?
      @this_user.can? :add, :blog_posts
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :blog_posts
    end

    def update?
      edit?
    end

    def destroy?
      @this_user.can? :destroy, :blog_posts
    end
  end
end
