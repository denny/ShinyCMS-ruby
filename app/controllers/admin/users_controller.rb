# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/users_controller.rb
# Purpose:   Controller for users section of ShinyCMS admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::UsersController < AdminController
  def index
    authorise User
    page_num = params[ :page ] || 1
    @users = User.order( :username ).page( page_num )
    authorise @users if @users.present?
  end

  def new
    @user = User.new
    authorise @user
  end

  def create
    @user = User.new( user_params )
    authorise @user

    if @user.save
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @user.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit
    @user = User.find( params[:id] )
    authorise @user
  end

  def update
    @user = User.find( params[:id] )
    authorise @user

    if @user.update_without_password( user_params )
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @user.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def destroy
    user = User.find( params[:id] )
    authorise user

    flash[ :notice ] = t( '.success' ) if user.destroy
    redirect_to users_path
  rescue ActiveRecord::RecordNotFound, ActiveRecord::NotNullViolation
    redirect_with_alert users_path, t( '.failure' )
  end

  private

  def user_params
    params.require( :user ).permit(
      :username, :email, :password, :display_name, :display_email,
      :profile_pic, :bio, :website, :location, :postcode, :admin_notes,
      capabilities: {}
    )
  end
end
