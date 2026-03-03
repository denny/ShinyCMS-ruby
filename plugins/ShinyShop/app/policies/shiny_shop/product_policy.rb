# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Pundit policy for products - part of the ShinyShop plugin for ShinyCMS
  class ProductPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :products
    end

    def new?
      @this_user.can? :add, :products
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :products
    end

    def update?
      edit?
    end

    def archive?
      edit?
    end

    def revive?
      edit?
    end
  end
end
