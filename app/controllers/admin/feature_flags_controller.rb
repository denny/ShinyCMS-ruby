# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/feature_flags_controller.rb
# Purpose:   Controller for feature flags section of ShinyCMS admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::FeatureFlagsController < AdminController
  def index
    @flags = FeatureFlag.all.order( :name )
    authorise FeatureFlag
    authorise @flags if @flags.present?
  end

  def update
    authorise FeatureFlag

    if FeatureFlag.update_all_flags( feature_flag_params )
      flash[ :notice ] = t( '.success' )
    else
      flash[ :alert  ] = t( '.failure' )
    end
    redirect_to action: :index
  end

  private

  def feature_flag_params
    params.require( :features ).permit( flags: {} )
  end
end
