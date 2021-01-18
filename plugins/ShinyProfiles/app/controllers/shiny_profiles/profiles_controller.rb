# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Main site controller for profile pages, provided by ShinyProfiles plugin for ShinyCMS
  class ProfilesController < MainController
    before_action :check_feature_flags, only: %i[ show ]
    before_action :stash_profile, only: %i[ show edit ]

    def index
      # TODO: searchable gallery of public user profiles
      redirect_to main_app.root_path
    end

    def show
      return if @profile.present?

      render 'errors/not_found', status: :not_found
    end

    def edit
      return if @profile.present?

      render 'errors/not_found', status: :not_found
    end

    def profile_redirect
      if user_signed_in?
        redirect_to shiny_profiles.profile_path( current_user.username )
      else
        redirect_to main_app.new_user_session_path
      end
    end

    private

    def stash_profile
      @profile = Profile.with_username params[ :username ]
    end

    def check_feature_flags
      enforce_feature_flags :user_profiles
    end
  end
end
