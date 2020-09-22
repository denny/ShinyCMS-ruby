# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Pundit policy for newsletter templates - part of the ShinyNewsletters plugin for ShinyCMS
  class TemplatePolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def index?
      @this_user.can? :list, :newsletter_templates
    end

    def new?
      @this_user.can? :add, :newsletter_templates
    end

    def create?
      new?
    end

    def edit?
      @this_user.can? :edit, :newsletter_templates
    end

    def update?
      edit?
    end

    def destroy?
      @this_user.can? :destroy, :newsletter_templates
    end
  end
end
