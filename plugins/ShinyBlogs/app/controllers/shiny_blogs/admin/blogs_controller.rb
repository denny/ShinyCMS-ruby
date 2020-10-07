# frozen_string_literal: true

# ShinyBlogs plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlogs
  # Admin controller for blogs, from ShinyBlogs plugin for ShinyCMS
  class Admin::BlogsController < AdminController
    before_action :set_blog, only: %i[ edit update destroy ]

    def index
      authorize ShinyBlogs::Blog
      @blogs = ShinyBlogs::Blog.all
      authorize @blogs if @blogs.present?
    end

    def new
      @blog = ShinyBlogs::Blog.new
      authorize @blog
    end

    def create
      @blog = ShinyBlogs::Blog.new( blog_params )
      authorize @blog

      if @blog.save
        redirect_to edit_blog_path( @blog ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      authorize @blog
    end

    def update
      return unless authorize @blog

      if @blog.update( blog_params )
        redirect_to edit_blog_path( @blog ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      return unless authorize @blog

      flash[ :notice ] = t( '.success' ) if @blog.destroy

      redirect_to blogs_path
    end

    private

    def set_blog
      @blog = ShinyBlogs::Blog.find( params[:id] )
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
end
