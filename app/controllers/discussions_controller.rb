# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/discussion_controller.rb
# Purpose:   Controller for discussion and comment features on a ShinyCMS site
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class DiscussionsController < MainController
  include AkismetHelper
  include RecaptchaHelper

  before_action :check_feature_flags
  before_action :stash_discussion, except: %i[ index ]
  before_action :stash_comment,    except: %i[ index show add_comment ]

  def index
    count = ( params[ :count ] || 10 ).to_i
    days  = ( params[ :days  ] || 7  ).to_i
    @active_discussions, @recent_comment_counts =
      Discussion.readonly.recently_active( days: days, count: count )
  end

  def show; end

  def show_thread
    return if @comment.present?

    @resource_type = 'Comment'
    render 'errors/404', status: :not_found
  end

  def add_comment
    @new_comment = @discussion.comments.new( comment_params )
    save_comment
  end

  def add_reply
    @new_comment = @comment.comments.new( comment_params )
    save_comment
  end

  def save_comment
    if new_comment_passes_checks_and_saves?
      flash[ :notice ] = t( '.success' ) unless @new_comment.spam?
      redirect_back fallback_location: discussion_path( @discussion )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :show
    end
  end

  private

  def stash_discussion
    @discussion = Discussion.readonly.find( params[ :id ] )
  rescue ActiveRecord::RecordNotFound
    render 'errors/404', status: :not_found
  end

  def stash_comment
    @comment = @discussion.comments.find_by( number: params[ :number ] ) || nil
  end

  def new_comment_passes_checks_and_saves?
    passes_akismet_check? && passes_recaptcha? && @new_comment.save
  end

  def passes_akismet_check?
    return true unless akismet_enabled? && akismet_api_key_is_set?

    spam, blatant = akismet_check( request, @new_comment )
    return false if blatant && drop_blatant_spam?

    @new_comment.spam = spam
    true
  end

  def passes_recaptcha?
    return true unless feature_enabled? :recaptcha_on_comment_form
    return true if     @new_comment.user_id.present?

    verify_invisible_recaptcha( 'comment' ) || verify_checkbox_recaptcha
  end

  def comment_params
    prms = params.require( :comment ).permit(
      %i[title body author_type author_name author_email author_url g-recaptcha-response[comment] g-recaptcha-response]
    )
    merge_user_id_and_discussion_id( prms )
  end

  def merge_user_id_and_discussion_id( prms )
    prms = prms.merge( user_id: current_user.id ) if user_signed_in?
    prms.merge( discussion_id: @discussion.id )
  end

  def check_feature_flags
    enforce_feature_flags :comments
  end
end
