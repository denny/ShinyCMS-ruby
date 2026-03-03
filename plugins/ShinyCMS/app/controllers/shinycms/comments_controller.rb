# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Main site controller for comment features - part of the ShinyCMS core plugin
  class CommentsController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    include ShinyCMS::WithAkismet
    include ShinyCMS::WithRecaptcha

    before_action :check_feature_flags
    before_action :stash_discussion
    before_action :stash_comment

    def index; end # view comment thread beginning with specified comment

    def show; end  # view single comment

    def new; end

    def create
      @new_comment = parent.comments.new( new_comment_details )

      if new_comment_passes_checks_and_saves?
        flash[ :notice ] = t( '.success' ) unless @new_comment.spam?
        redirect_back_or_to discussion_path( @discussion )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    private

    def stash_discussion
      @discussion = Discussion.readonly.find params[ :id ]
    end

    def stash_comment
      number = params[:number]
      return if number.blank?

      @comment = @discussion.find_comment( number: number )
    end

    def parent
      @comment || @discussion
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
      comment_params = { author: comment_author, ip_address: request.ip }
      comment_params.merge!( strong_params.except( :author_type, :author_name, :author_email, :author_url ) )
      comment_params.merge!( discussion_id: @discussion.id )
    end

    def comment_author
      authenticated_author || pseudonymous_author || ShinyCMS::AnonymousAuthor.get
    end

    def authenticated_author
      return unless strong_params[ :author_type ] == 'authenticated' && user_signed_in?

      current_user
    end

    def pseudonymous_author
      return unless strong_params[ :author_type ] == 'pseudonymous' && strong_params[ :author_name ].present?

      author = new_pseudonymous_author
      return author if strong_params[ :author_email ].blank?

      author_with_email_recipient( author )
    end

    def new_pseudonymous_author
      PseudonymousAuthor.new(
        name:       strong_params[ :author_name ],
        url:        strong_params[ :author_url ].presence,
        ip_address: request.ip
      )
    end

    def author_with_email_recipient( author )
      author.email_recipient = EmailRecipient.find_or_initialize_by(
        email: strong_params[ :author_email ]
      )
      author
    end

    def strong_params
      params.expect( comment: %i[ title body author_type author_name author_email author_url ] )
    end

    def check_feature_flags
      enforce_feature_flags :comments
    end
  end
end
