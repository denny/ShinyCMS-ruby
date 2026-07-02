# frozen_string_literal: true

# ShinyProfiles plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyProfiles
  # Main site controller for profile pages, provided by ShinyProfiles plugin for ShinyCMS
  class ProfilesController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    before_action :check_feature_flags
    before_action :authenticate_user!,         except: %i[ index show  ]
    before_action :stash_profile,              only:   %i[ show        ]
    before_action :stash_current_user_profile, only:   %i[ edit update ]
    before_action :redirect_to_show_requested, only:   %i[ edit        ]
    before_action :redirect_to_edit_self,      only:   %i[ update      ]

    def index
      # TODO: searchable gallery of public user profiles
      redirect_to main_app.root_path
    end

    def show; end

    def profile_redirect
      redirect_to shiny_profiles.profile_path( current_user.username )
    end

    def edit; end

    def update
      flash[ :notice ] = t( '.success' ) if add_new_links && @profile.update( strong_params )

      redirect_to shiny_profiles.edit_profile_path( @profile.username )
    end

    private

    def stash_profile
      @profile = Profile.for_username params[ :username ]
    end

    def stash_current_user_profile
      @profile = current_user.full_profile
    end

    def redirect_to_show_requested
      return if current_user_matches_username_in_url?

      redirect_to shiny_profiles.profile_path( params[ :username] )
    end

    def redirect_to_edit_self
      return if current_user_matches_username_in_url?

      redirect_to shiny_profiles.edit_profile_path( current_user.username )
    end

    def current_user_matches_username_in_url?
      params[ :username] == current_user.username
    end

    def strong_params
      # rubocop:disable Layout/LineLength
      params.expect(
        profile: %i[
          public_name public_email profile_pic bio location postcode new_link_name: [], new_link_url: [], links_attributes: {}
        ]
      )
      # rubocop:enable Layout/LineLength
    end

    def add_new_links
      names = params[ :profile ]&.delete( :new_link_name )
      urls  = params[ :profile ]&.delete( :new_link_url  )

      return true if urls.nil?

      urls.each_with_index do |url, i|
        next if url.blank?

        name = names[i] || url

        @profile.links.create!( name: name, url: url )
      end
    end

    def check_feature_flags
      enforce_feature_flags :user_profiles
    end
  end
end
