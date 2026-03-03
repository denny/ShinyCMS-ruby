# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for users section of ShinyCMS admin area
  class Admin::UsersController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    before_action :stash_new_user, only: %i[ new create ]
    before_action :stash_user,     only: %i[ edit update destroy ]

    def index
      authorize User

      users = ShinyCMS.plugins.loaded?( :ShinyProfiles ) ? User.with_profiles : User

      @pagy, @users = pagy( users.order( :username ) )

      authorize @users if @users.present?
    end

    def search
      authorize User

      users = ShinyCMS.plugins.loaded?( :ShinyProfiles ) ? User.with_profiles : User

      @pagy, @users = pagy( users.admin_search( params[:q] ) )

      authorize @users if @users.present?
      render :index
    end

    def username_search
      authorize User

      users = User.where( 'username ilike ?', "%#{params[ :term ]}%" ).pluck( :username )

      render json: users
    end

    def new
      authorize @user
    end

    def create
      authorize @user

      if @user.save
        redirect_to edit_user_path( @user ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      authorize @user
    end

    def update
      authorize @user
      @user.skip_reconfirmation!

      if @user.update_without_password( strong_params )
        redirect_to edit_user_path( @user ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      authorize @user

      if @user.destroy
        redirect_to users_path, notice: t( '.success' )
      else
        redirect_to users_path, alert: t( '.failure' )
      end
    end

    private

    def stash_new_user
      @user = User.new( strong_params )
    end

    def stash_user
      @user = User.find( params[:id] )
    end

    def strong_params
      return unless params[ :user ]

      params.expect( user: [ :username, :email, :password, :admin_notes, { capabilities: {} } ] )
    end
  end
end
