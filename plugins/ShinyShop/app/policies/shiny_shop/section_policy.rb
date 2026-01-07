# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Pundit policy for product sections - part of the ShinyShop plugin for ShinyCMS
  class SectionPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :product_sections
    end

    def new?
      @this_user.can? :add, :product_sections
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :product_sections
    end

    def update?
      edit?
    end

    def destroy?
      @this_user.can? :destroy, :product_sections
    end
  end
end
