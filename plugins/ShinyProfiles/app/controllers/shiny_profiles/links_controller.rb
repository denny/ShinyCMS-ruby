# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Main site controller for profile links, provided by ShinyProfiles plugin for ShinyCMS
  class LinksController < MainController
    before_action :check_feature_flags
    before_action :authenticate_user!
    before_action :stash_profile
    before_action :authorize_user
    before_action :stash_link

    def destroy
      status = @link.destroy ? :no_content : :bad_request
      head status
    end

    private

    def stash_profile
      @profile = Profile.for_username params[ :username ]
    end

    def authorize_user
      return if current_user == @profile&.user

      head :unauthorized
    end

    def stash_link
      return if ( @link = @profile.links.find_by id: params[ :id ] )

      head :no_content
    end

    def check_feature_flags
      return if FeatureFlag.enabled? :user_profiles

      head :not_found
    end
  end
end
