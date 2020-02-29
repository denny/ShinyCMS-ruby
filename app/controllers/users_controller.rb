# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/users_controller.rb
# Purpose:   Controller for user profile pages on a ShinyCMS-powered site
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class UsersController < ApplicationController
  before_action :check_feature_flags, only: %i[ show ]

  def index
    if user_signed_in?
      redirect_to user_profile_path( current_user.username )
    else
      redirect_to new_user_session_path
    end
  end

  def show
    @user_profile = User.find_by( username: params[ :username ] )
    return if @user_profile.present?

    render 'errors/404', status: :not_found
  end

  private

  def check_feature_flags
    enforce_feature_flags :user_profiles
  end
end
