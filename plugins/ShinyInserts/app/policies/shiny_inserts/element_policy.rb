# frozen_string_literal: true

# ============================================================================
# Project:   ShinyInserts plugin for ShinyCMS (Ruby version)
# File:      plugins/ShinyInserts/app/policies/shiny_inserts/element_policy.rb
# Purpose:   Pundit policy for admin area features
#
# Copyright 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================

module ShinyInserts
  # Pundit policy for Insert elements - part of the ShinyInserts plugin for ShinyCMS
  class ElementPolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def create?
      @this_user.can? :add, :inserts
    end

    def destroy?
      @this_user.can? :destroy, :inserts
    end
  end
end
