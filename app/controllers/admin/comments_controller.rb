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

  before_action :stash_comment, except: %i[ index update ]

  # Display spam comment moderation page
  def index
    page_num = params[ :page ] || 1
    @comments = Comment.all_spam.page( page_num )
    authorise Comment
    authorise @comments if @comments.present?
  end

  # Process submission of spam comment moderation page
  def update
    authorise Comment
    the_params = update_params
    if the_params[ :spam_or_ham ] == 'spam'
      process_spam_comments
    elsif the_params[ :spam_or_ham ] == 'ham'
      process_ham_comments
    else
      flash[ :alert ] = t( '.spam_or_ham' )
    end

    redirect_to action: :index
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
    contextual_path = comment_in_context_path( @comment )
    @comment.delete
    redirect_to request.referer || contextual_path
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

  def update_params
    params.permit(
      :authenticity_token, :commit, :_method, spam_comments: {}
    )[ :spam_comments ] || {}
  end

  def process_spam_comments
    tell_akismet_about_spam
    if Comment.where( id: selected_comment_ids ).destroy
      flash[ :notice ] = t( 'admin.comments.process_ham_comments.success' )
    else
      flash[ :alert ] = t( 'admin.comments.process_ham_comments.failure' )
    end
  end

  def process_ham_comments
    tell_akismet_about_ham
    if Comment.where( id: selected_comment_ids ).update( spam: false )
      flash[ :notice ] = t( 'admin.comments.process_ham_comments.success' )
    else
      flash[ :alert ] = t( 'admin.comments.process_ham_comments.failure' )
    end
  end

  def tell_akismet_about_spam
    # comment_ids = selected_comment_ids
    # TODO: Open a connection to Akismet
    # Loop through the selected comments telling Akismet that they are spam
  end

  def tell_akismet_about_ham
    # comment_ids = selected_comment_ids
    # TODO: Open a connection to Akismet
    # Loop through the selected comments telling Akismet that they are not spam
  end

  def selected_comment_ids
    comment_ids = []
    the_params = update_params
    the_params.each_key do |name|
      comment_id = name.match %r{comment_(\d+)}
      next if comment_id.nil?

      comment_ids << comment_id[1].to_i if update_params[ name ] == '1'
    end
    comment_ids
  end
end
