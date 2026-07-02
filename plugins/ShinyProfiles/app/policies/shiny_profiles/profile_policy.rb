# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Pundit policy for user profiles - part of the ShinyProfiles plugin for ShinyCMS
  class ProfilePolicy
    attr_reader :this_user, :record

    def initialize( this_user, record )
      @this_user = this_user
      @record = record
    end

    def edit?
      @this_user.can? :edit, :users
    end

    def update?
      edit?
    end
  end
end
