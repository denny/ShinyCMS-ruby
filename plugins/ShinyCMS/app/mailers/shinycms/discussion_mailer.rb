# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Mailer for discussion-related emails (reply notifications, etc)
  class DiscussionMailer < ApplicationMailer
    before_action :stash_content
    before_action :stash_parent_comment_author, only: :parent_comment_author_notification
    before_action :stash_content_author,        only: :content_author_notification
    before_action :stash_comment_admin,         only: :comment_admin_notification
    before_action :add_view_path

    def parent_comment_author_notification
      return if @user.blank?

      mail to: @user.email_to, subject: parent_comment_author_notification_subject do |format|
        format.html
        format.text
      end
    end

    def content_author_notification
      mail to: @user.email_to, subject: content_author_notification_subject do |format|
        format.html
        format.text
      end
    end

    def comment_admin_notification
      mail to: @user.email_to, subject: comment_admin_notification_subject do |format|
        format.html
        format.text
      end
    end

    # Trigger as many of the above as is appropriate for a given comment
    def self.send_notifications( comment )
      parent_author  = comment.parent&.notification_email
      content_author = comment.discussion.notification_email
      admin          = ShinyCMS::Setting.get :all_comment_notifications_email

      with_comment = with( comment: comment )

      with_comment.parent_comment_author_notification if parent_author.present?

      with_comment.content_author_notification unless blank_or_already_emailed? content_author, [ parent_author ]

      with_comment.comment_admin_notification unless blank_or_already_emailed? admin, [ parent_author, content_author ]
    end

    def self.blank_or_already_emailed?( email, previous_emails )
      ( [ nil ] + previous_emails ).include? email
    end

    private

    def check_feature_flags
      enforce_feature_flags :comment_notifications
    end

    def stash_content
      @comment = params[:comment]
      @parent  = @comment.parent
      @content = @comment.discussion.resource
    end

    def stash_parent_comment_author
      email = @parent.notification_email
      return if email.blank?

      @user = notified_user( email, @parent.author.name )
    end

    def stash_content_author
      author = @content.author
      email  = author.email
      return if email.blank?

      @user = notified_user( email, author.name )
    end

    def stash_comment_admin
      admin_email = ShinyCMS::Setting.get :all_comment_notifications_email
      @user = notified_user admin_email
    end

    def check_ok_to_email
      enforce_ok_to_email @user if @user.present?
    end

    def add_view_path
      add_to_view_paths 'plugins/ShinyCMS/app/views/shinycms'
    end

    def parent_comment_author_notification_subject
      I18n.t(
        'shinycms.discussion_mailer.parent_comment_author_notification.subject',
        comment_author_name: @comment.author.name,
        site_name:           site_name
      )
    end

    def content_author_notification_subject
      I18n.t(
        'shinycms.discussion_mailer.content_author_notification.subject',
        comment_author_name: @comment.author.name,
        content_type:        @content.class.readable_name,
        site_name:           site_name
      )
    end

    def comment_admin_notification_subject
      I18n.t(
        'shinycms.discussion_mailer.comment_admin_notification.subject',
        comment_author_name: @comment.author.name,
        site_name:           site_name
      )
    end
  end
end
