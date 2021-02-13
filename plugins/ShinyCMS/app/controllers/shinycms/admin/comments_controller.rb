# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for ShinyCMS comment admin features
  class Admin::CommentsController < AdminController
    include AkismetHelper

    before_action :stash_comment, except: %i[ index search update ]

    helper_method :pagy_url_for

    # Display spam comment moderation page
    def index
      authorize Comment
      @pagy, @comments = pagy( Comment.spam, items: items_per_page )
      authorize @comments if @comments.present?
    end

    def search
      authorize Comment

      @pagy, @comments = pagy( Comment.admin_search( params[:q] ), items: items_per_page )

      authorize @comments if @comments.present?
      render :index
    end

    # Process submission of spam comment moderation page
    def update
      authorize Comment
      case update_params[ :spam_or_ham ]
      when 'spam'
        process_spam_comments
      when 'ham'
        process_ham_comments
      else
        flash[ :alert ] = t( '.spam_or_ham' )
      end

      redirect_to action: :index
    end

    def show
      authorize @comment
      @comment.show
      redirect_back fallback_location: @comment.anchored_path
    end

    def hide
      authorize @comment
      @comment.hide
      redirect_back fallback_location: @comment.anchored_path
    end

    def lock
      authorize @comment
      @comment.lock
      redirect_back fallback_location: @comment.anchored_path
    end

    def unlock
      authorize @comment
      @comment.unlock
      redirect_back fallback_location: @comment.anchored_path
    end

    def destroy
      authorize @comment
      @comment.destroy!
      redirect_back fallback_location: @comment.anchored_path
    end

    def mark_as_spam
      authorize @comment
      @comment.mark_as_spam
      redirect_back fallback_location: @comment.anchored_path
    end

    private

    def stash_comment
      @comment = Comment.find( params[ :id ] )
    end

    def update_params
      params.permit(
        :authenticity_token, :commit, :spam_or_ham, :_method, spam_comments: {}
      ) || {}
    end

    def process_spam_comments
      akismet_confirm_spam( selected_comment_ids )
      Comment.destroy_by( id: selected_comment_ids )
      flash[ :notice ] = t( 'admin.comments.process_spam_comments.success' )
    end

    def process_ham_comments
      akismet_flag_as_ham( selected_comment_ids )

      if Comment.mark_all_as_ham( selected_comment_ids )
        flash[ :notice ] = t( 'admin.comments.process_ham_comments.success' )
      else
        flash[ :alert ] = t( 'admin.comments.process_ham_comments.failure' )
      end
    end

    def selected_comment_ids
      comment_ids = []
      update_params[ :spam_comments ].each_pair do |key, value|
        next unless value == '1'

        comment_id = key.match %r{comment_(\d+)}
        next if comment_id.nil?

        comment_ids << comment_id[1].to_i
      end
      comment_ids
    end

    # Override pager link format (to admin/action/page/NN rather than admin/action?page=NN)
    def pagy_url_for( page, _pagy )
      params = request.query_parameters.merge( only_path: true, page: page )
      url_for( params )
    end
  end
end
