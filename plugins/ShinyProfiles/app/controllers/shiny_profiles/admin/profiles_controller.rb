# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Controller for admin updates to user profiles - part of the ShinyProfiles plugin for ShinyCMS
  class Admin::ProfilesController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    before_action :stash_profile

    def edit
      authorize @profile
    end

    def update
      authorize @profile

      flash[ :notice ] = t( '.success' ) if @profile.update( strong_params )

      redirect_to admin_edit_profile_path( @profile )
    end

    def breadcrumb_section_path
      shinycms.users_path
    end

    private

    def stash_profile
      @profile = Profile.with_links.with_pic.find params[ :id ]
    end

    def strong_params
      params.expect( profile: %i[ public_name public_email profile_pic bio location postcode ] )
    end
  end
end
