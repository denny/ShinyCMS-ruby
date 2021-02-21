# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
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

    def show_thread; end

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
      @discussion = Discussion.readonly.find params[ :id ]
    end

    def stash_comment
      @comment = @discussion.find_comment( number: params[ :number ] )
    end

    def new_comment_passes_checks_and_saves?
      check_locks && check_with_recaptcha && check_with_akismet && @new_comment.save
    end

    def check_locks
      return false if @discussion.locked?
      return true  if @comment.blank?

      !@comment.locked?
    end

    def check_with_recaptcha
      return true if user_signed_in?
      return true unless feature_enabled? :recaptcha_for_comments

      verify_invisible_recaptcha( 'comments' ) || verify_checkbox_recaptcha
    end

    def check_with_akismet
      return true if user_signed_in?
      return true unless akismet_api_key_is_set? && feature_enabled?( :akismet_for_comments )

      spam, blatant = akismet_check( request, @new_comment )
      if blatant && Setting.true?( :akismet_drop_blatant_spam )
        Rails.logger.info( "Blatant spam comment dropped: #{@new_comment}" ) if Setting.true? :akismet_log_blatant_spam
        return false
      end

      @new_comment.spam = spam
      true
    end

    def new_comment_details
      comment_params = { author: find_author, ip_address: request.ip }
      comment_params.merge!( strong_params.except( :author_type, :author_name, :author_email, :author_url ) )
      comment_params.merge!( discussion_id: @discussion.id )
    end

    def find_author
      return create_comment_author if strong_params[ :author_name ].present?

      current_user if user_signed_in? && strong_params[ :author_type ] != 'anonymous'
    end

    def create_comment_author
      author = CommentAuthor.new(
        name:       strong_params[ :author_name ],
        website:    strong_params[ :author_url ].presence,
        ip_address: request.ip
      )
      return author if strong_params[ :author_email ].blank?

      recipient = EmailRecipient.find_or_initialize_by( email: strong_params[ :author_email ] )
      author.email_recipient = recipient
      author
    end

    def strong_params
      params.require( :comment ).permit( %i[ title body author_type author_name author_email author_url ] )
    end

    def check_feature_flags
      enforce_feature_flags :comments
    end
  end
end
