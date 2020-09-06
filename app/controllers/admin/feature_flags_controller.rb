# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for feature flags section of ShinyCMS admin area
class Admin::FeatureFlagsController < AdminController
  def index
    authorise FeatureFlag
    @flags = FeatureFlag.all.order( :name )
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
