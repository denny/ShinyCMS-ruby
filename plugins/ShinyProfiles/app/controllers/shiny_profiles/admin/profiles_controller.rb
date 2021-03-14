# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Controller for admin updates to user profiles - part of the ShinyProfiles plugin for ShinyCMS
  class Admin::ProfilesController < AdminController
    before_action :stash_profile

    def edit
      authorize @profile
    end

    def update
      authorize @profile

      flash[ :notice ] = t( '.success' ) if @profile.update( strong_params )

      redirect_to admin_edit_profile_path( @profile )
    end

    # Override the breadcrumbs section link to go back to the user list
    def breadcrumb_link_text_and_path
      [ t( 'shinycms.admin.users.breadcrumb' ), shinycms.users_path ]
    end

    private

    def stash_profile
      @profile = Profile.with_links.with_pic.find params[ :id ]
    end

    def strong_params
      params.require( :profile ).permit(
        :public_name, :public_email, :profile_pic, :bio, :location, :postcode
      )
    end
  end
end
