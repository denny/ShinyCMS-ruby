# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for discussion and comment features on a ShinyCMS site
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

    render 'errors/404', status: :not_found, locals: { resource_type: 'comment' }
  end

  def add_comment
    @new_comment = @discussion.comments.new( new_comment_details )
    save_comment
  end

  def add_reply
    @new_comment = @comment.comments.new( new_comment_details )
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
    return true if passes_recaptcha? && set_akismet_spam_flag && @new_comment.save

    # raise ActiveRecord::Rollback
  end

  def passes_recaptcha?
    return true unless feature_enabled? :recaptcha_for_comments
    return true if     @new_comment.authenticated_author?

    verify_invisible_recaptcha( 'comment' ) || verify_checkbox_recaptcha
  end

  def log_blatant_spam?
    Setting.true?( :log_blatant_spam )
  end

  def set_akismet_spam_flag
    return true unless akismet_api_key_is_set? && akismet_enabled?

    spam, blatant = akismet_check( request, @new_comment )
    if blatant && drop_blatant_spam?
      Rails.logger.info( "Blatant spam comment dropped: #{@new_comment}" ) if log_blatant_spam?
      return false
    end

    @new_comment.spam = spam
    true
  end

  def new_comment_details
    form_params = { author: find_author }
    form_params.merge!( strong_params.except( :author_name, :author_email, :author_url ) )
    form_params.merge!( discussion_id: @discussion.id )
  end

  def find_author
    author = current_user if user_signed_in?
    author ||= create_comment_author if strong_params[ :author_name ].present?
    author
  end

  def create_comment_author
    author = CommentAuthor.create!(
      name: strong_params[ :author_name ],
      website: strong_params[ :author_url ].presence,
      ip_address: request.ip
    )
    return author if strong_params[ :author_email ].blank?

    recipient = EmailRecipient.create_or_find_by!( email: strong_params[ :author_email ] )
    author.update!( email_recipient: recipient )
    author
  end

  def strong_params
    params.require( :comment ).permit(
      %i[ title body author_name author_email author_url g-recaptcha-response[comment] g-recaptcha-response ]
    )
  end

  def check_feature_flags
    enforce_feature_flags :comments
  end
end
