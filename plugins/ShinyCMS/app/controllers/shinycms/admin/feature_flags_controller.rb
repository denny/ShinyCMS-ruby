# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for feature flags section of ShinyCMS admin area
  class Admin::FeatureFlagsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    def index
      authorize FeatureFlag
      @flags = FeatureFlag.order( :name )
      authorize @flags if @flags.present?
    end

    def update
      authorize FeatureFlag

      if FeatureFlag.update_all_flags( feature_flag_params )
        flash[ :notice ] = t( '.success' )
      else
        flash[ :alert  ] = t( '.failure' )
      end
      redirect_to action: :index
    end

    private

    def feature_flag_params
      params.expect( features: [ flags: {} ] )
    end
  end
end
