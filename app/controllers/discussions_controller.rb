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
class DiscussionsController < ApplicationController
  include RecaptchaHelper

  before_action :check_feature_flags
  before_action :stash_discussion, except: %i[ index ]
  before_action :stash_comment,    except: %i[ index show add_comment ]

  def index
    # TODO: list of recently-active discussions etc
    redirect_to root_path
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
    if akismet_check && recaptcha_pass && @new_comment.save
      flash[ :notice ] = t( '.success' ) unless @new_comment.spam?
      redirect_back fallback_location: discussion_path( @discussion )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :show
    end
  end

  private

  def stash_discussion
    @discussion = Discussion.find( params[ :id ] )
  rescue ActiveRecord::RecordNotFound
    render 'errors/404', status: :not_found
  end

  def stash_comment
    @comment = @discussion.comments.find_by( number: params[ :number ] ) || nil
  end

  def recaptcha_pass
    return true unless feature_enabled? :recaptcha_on_comment_form
    return true if     @new_comment.user_id.present?

    verify_invisible_recaptcha( 'comment' ) || verify_checkbox_recaptcha
  end

  def akismet_check
    return true unless feature_enabled? :akismet_on_comments

    key = self.class.akismet_api_key
    return true if key.blank?

    Akismet.api_key = key
    Akismet.app_url = root_url

    # Akismet.check throws "Akismet::Error: unknown error" for invalid API keys!
    spam, blatant = Akismet.check request.ip, request.user_agent, akismet_params
    return false if blatant && setting( :akismet_blatant_spam ) != 'Keep'

    @new_comment.spam = spam
    true
  end

  def akismet_params
    params = {
      text: "#{@new_comment.title} #{@new_comment.body}",
      author: akismet_author_name,
      created_at: Time.zone.now,
      referrer: request.referer,
      type: 'comment'
    }
    params[ :author_email ] = akismet_author_email if akismet_author_email
    params[ :author_url   ] = akismet_author_url   if akismet_author_url
    params
  end

  def akismet_author_name
    @new_comment.author_name || @new_comment.author&.username || 'Anonymous'
  end

  def akismet_author_email
    @new_comment.author_email || @new_comment.author&.email
  end

  def akismet_author_url
    @new_comment.author_url || @new_comment.author&.website
  end

  def comment_params
    p = params.require( :comment ).permit( permitted_param_names )
    p = p.merge( user_id: current_user.id ) if user_signed_in?
    p.merge( discussion_id: @discussion.id )
  end

  def permitted_param_names
    %i[
      title
      body
      author_type
      author_name
      author_email
      author_url
      g-recaptcha-response[comment]
      g-recaptcha-response
    ]
  end

  def check_feature_flags
    enforce_feature_flags :comments
  end
end
