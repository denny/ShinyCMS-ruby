# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Main site controller for profile pages, provided by ShinyProfiles plugin for ShinyCMS
  class ProfilesController < MainController
    before_action :check_feature_flags, only: %i[ show ]

    def index
      # TODO: searchable gallery of public user profiles
      redirect_to main_app.root_path
    end

    def show
      @user_profile = User.readonly.find_by( username: params[ :username ] )
      return if @user_profile.present?

      render 'errors/404', status: :not_found
    end

    def profile_redirect
      if user_signed_in?
        redirect_to shiny_profiles.profile_path( current_user.username )
      else
        redirect_to main_app.new_user_session_path
      end
    end

    private

    def check_feature_flags
      enforce_feature_flags :profile_pages
    end
  end
end
