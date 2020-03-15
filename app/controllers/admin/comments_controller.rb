# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/comments_controller.rb
# Purpose:   Controller for ShinyCMS comment/discussion admin features
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::CommentsController < AdminController
  include MainSiteHelper

  before_action :stash_comment, except: %i[ index ]

  # Display spam comment moderation page
  def index
    page_num = params[ :page ] || 1
    @comments = Comment.all_spam.page( page_num )
    authorise Comment
    authorise @comments if @comments.present?
  end

  # Process submission of spam comment moderation page
  def update
    # Get the IDs of all the selected comments
    ids = param[ :id ]
    # Are we rescuing ham, or confirming spam?
    if param[ :spam_or_ham ] == 'spam'
      # Open a connection to Akismet
      # Loop through the selected comments
    else
      # And clear their spam flag
      Comment.where( id: ids ).update!( spam: false )
    end
  end

  def hide
    authorise @comment
    @comment.hide
    redirect_to request.referer || comment_in_context_path( @comment )
  end

  def unhide
    authorise @comment
    @comment.unhide
    redirect_to request.referer || comment_in_context_path( @comment )
  end

  def lock
    authorise @comment
    @comment.lock
    redirect_to request.referer || comment_in_context_path( @comment )
  end

  def unlock
    authorise @comment
    @comment.unlock
    redirect_to request.referer || comment_in_context_path( @comment )
  end

  def delete
    authorise @comment
    @comment.delete
    redirect_to request.referer || comment_in_context_path( @comment )
  end

  def mark_as_spam
    authorise @comment
    @comment.mark_as_spam
    redirect_to request.referer || comment_in_context_path( @comment )
  end

  private

  def stash_comment
    @comment = Comment.find( params[ :id ] )
  end
end
