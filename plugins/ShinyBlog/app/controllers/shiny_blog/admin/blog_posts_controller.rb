# frozen_string_literal: true

# ShinyBlog plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyBlog
  # Admin area controller for ShinyBlog plugin for ShinyCMS
  class Admin::BlogPostsController < AdminController
    include ShinyDiscussionAdmin
    include ShinyPostAdmin

    include ShinyDateHelper
    include ShinyPagingHelper

    before_action :set_post_for_create, only: :create
    before_action :set_post, only: %i[ edit update destroy ]

    def index
      authorise Post
      @posts = Post.order( created_at: :desc ).page( page_number )
      authorise @posts if @posts.present?
    end

    def new
      @post = Post.new
      authorise @post
    end

    def create
      authorise @post

      if @post.save
        redirect_to shiny_blog.edit_blog_post_path( @post ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      authorise @post
    end

    def update
      authorise @post

      if @post.update( strong_params_for_update )
        redirect_to shiny_blog.edit_blog_post_path( @post ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      authorise @post

      flash[ :notice ] = t( '.success' ) if @post.destroy
      redirect_to blog_posts_path
    end

    private

    def set_post
      @post = Post.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      redirect_to blog_posts_path, alert: t( 'shiny_blog.admin.blog_posts.set_post.not_found' )
    end

    def set_post_for_create
      show, lock = extract_discussion_flags_from_params( params[:post] )

      @post = Post.new( strong_params_for_create )

      create_discussion_or_update_flags( @post, show, lock ) if show
    end

    def strong_params_for_create
      enforce_change_author_capability_for_create( :blog_posts )

      temp_params = params.require( :post ).permit(
        :title, :slug, :body, :tag_list, :show_on_site, :user_id, :posted_at, :posted_at_time
      )

      combine_date_and_time_params( temp_params, :posted_at )
    end

    def strong_params_for_update
      show, lock = extract_discussion_flags_from_params( params[:post] )
      create_discussion_or_update_flags( @post, show, lock )

      enforce_change_author_capability_for_update( :blog_posts )

      temp_params = params.require( :post ).permit(
        :title, :slug, :body, :tag_list, :show_on_site, :user_id, :posted_at, :posted_at_time
      )

      combine_date_and_time_params( temp_params, :posted_at )
    end
  end
end
