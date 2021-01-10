# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for users section of ShinyCMS admin area
class Admin::UsersController < AdminController
  before_action :stash_new_user, only: %i[ new create ]
  before_action :stash_user,     only: %i[ edit update destroy ]

  helper_method :pagy_url_for

  def index
    authorize User
    @pagy, @users = pagy( User.order( :username ), items: items_per_page )
    authorize @users if @users.present?
  end

  def search
    authorize User

    search_term = params[:q]

    @pagy, @users = pagy(
      User.where( 'username ilike ?', "%#{search_term}%" )
          .or( User.where( 'email ilike ?', "%#{search_term}%" ) )
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

    if @user.update_without_password( user_params )
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
