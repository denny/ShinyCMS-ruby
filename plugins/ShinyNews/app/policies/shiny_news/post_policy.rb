# frozen_string_literal: true

# ShinyNews plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNews
  # Pundit policy for news posts - part of the ShinyNews plugin for ShinyCMS
  class PostPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :news_posts
    end

    def search?
      index?
    end

    def new?
      @this_user.can? :add, :news_posts
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :news_posts
    end

    def update?
      edit?
    end

    def destroy?
      @this_user.can? :destroy, :news_posts
    end
  end
end
