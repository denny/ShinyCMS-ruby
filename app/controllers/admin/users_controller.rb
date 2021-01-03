# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for users section of ShinyCMS admin area
class Admin::UsersController < AdminController
  helper_method :pagy_url_for

  def index
    authorize User
    @pagy, @users = pagy( User.order( :username ), items: items_per_page )
    authorize @users if @users.present?
  end

  def search
    authorize User

    q = params[:q]
    @pagy, @users = pagy(
      User.where( 'username ilike ?', "%#{q}%" )
          .or( User.where( 'public_name  ilike ?', "%#{q}%" )
          .or( User.where( 'public_email ilike ?', "%#{q}%" ) ) )
          .order( :username ), items: items_per_page
    )

    authorize @users if @users.present?
    render :index
  end

  def username_search
    authorize User

    users = User.where( 'username ilike ?', "%#{params[ :term ]}%" ).pluck( :username )

    render json: users
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new( user_params )
    authorize @user

    if @user.save
      redirect_to edit_user_path( @user ), notice: t( '.success' )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit
    @user = User.find( params[:id] )
    authorize @user
  end

  def update
    @user = User.find( params[:id] )
    authorize @user
    @user.skip_reconfirmation!

    if @user.update_without_password( user_params )
      redirect_to edit_user_path( @user ), notice: t( '.success' )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def destroy
    user = User.find( params[:id] )
    authorize user

    flash[ :notice ] = t( '.success' ) if user.destroy
    redirect_to users_path
  rescue ActiveRecord::RecordNotFound, ActiveRecord::NotNullViolation
    skip_authorization
    redirect_to users_path, alert: t( '.failure' )
  end

  private

  def user_params
    params.require( :user ).permit(
      :username, :email, :password, :public_name, :public_email,
      :profile_pic, :bio, :website, :location, :postcode, :admin_notes,
      capabilities: {}
    )
  end

  # Override pager link format (to admin/action/page/NN rather than admin/action?page=NN)
  def pagy_url_for( page, _pagy )
    params = request.query_parameters.merge( only_path: true, page: page )
    url_for( params )
  end
end
