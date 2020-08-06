# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/blogs_controller.rb
# Purpose:   Controller for blogs section of ShinyCMS admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::BlogsController < AdminController
  before_action :set_blog, only: %i[ edit update destroy ]

  def index
    authorise Blog
    @blogs = Blog.all
    authorise @blogs if @blogs.present?
  end

  def new
    @blog = Blog.new
    authorise @blog
  end

  def create
    @blog = Blog.new( blog_params )
    authorise @blog

    if @blog.save
      redirect_to edit_blog_path( @blog ), notice: t( '.success' )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit
    authorise @blog
  end

  def update
    authorise @blog

    if @blog.update( blog_params )
      redirect_to edit_blog_path( @blog ), notice: t( '.success' )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def destroy
    authorise @blog

    flash[ :notice ] = t( '.success' ) if @blog.destroy
    redirect_to action: :index
  end

  private

  def set_blog
    @blog = Blog.find( params[:id] )
  rescue ActiveRecord::RecordNotFound
    skip_authorization
    redirect_to blogs_path, alert: t( '.failure' )
  end

  def blog_params
    params.require( :blog ).permit(
      :internal_name, :public_name, :slug, :description, :user_id, :show_on_site, :show_in_menus
    )
  end
end
