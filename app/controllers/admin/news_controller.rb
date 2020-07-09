# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/news_controller.rb
# Purpose:   Controller for news section of ShinyCMS admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::NewsController < AdminController
  before_action :set_post_for_create, only: :create
  before_action :set_post, only: %i[ edit update destroy ]
  before_action :update_discussion_flags, only: %i[ create update ]

  def index
    authorise NewsPost
    page_num = params[ :page ] || 1
    @posts = NewsPost.order( :created_at ).page( page_num )
    authorise @posts if @posts.present?
  end

  def new
    @post = NewsPost.new
    authorise @post
  end

  def create
    authorise @post

    if @post.save
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @post.id
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

    if @post.update( post_params )
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @post.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def update_discussion_flags
    hidden, locked = extract_discussion_flags

    return if @post.discussion.blank?

    @post.discussion.update!( hidden: hidden, locked: locked )
  end

  def destroy
    authorise @post

    flash[ :notice ] = t( '.success' ) if @post.destroy
    redirect_to action: :index
  end

  private

  def set_post
    @post = NewsPost.find( params[:id] )
  rescue ActiveRecord::RecordNotFound
    skip_authorization
    redirect_with_alert news_path, t( '.failure' )
  end

  def post_params
    params[ :news_post ].delete( :user_id ) unless current_user.can? :change_author, :news_posts

    params.require( :news_post ).permit(
      :user_id, :title, :slug, :tag_list, :posted_at, :body, :hidden, :discussion_hidden, :discussion_locked
    )
  end

  def set_post_for_create
    @post = NewsPost.new( post_params_for_create )
  end

  def post_params_for_create
    set_current_user_as_author_unless_admin

    params.require( :news_post ).permit(
      :user_id, :title, :slug, :tag_list, :posted_at, :body, :hidden, :discussion_hidden, :discussion_locked
    )
  end

  def extract_discussion_flags
    hidden = params[ :news_post].delete( :discussion_hidden ) || 0
    locked = params[ :news_post].delete( :discussion_locked ) || 0
    [ hidden, locked ]
  end

  def set_current_user_as_author_unless_admin
    params[ :news_post ][ :user_id ] = current_user.id unless current_user.can? :change_author, :news_posts
  end
end
