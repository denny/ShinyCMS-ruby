# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Mailer for discussion-related emails (reply notifications, etc)
  class DiscussionMailer < ApplicationMailer
    before_action :check_feature_flags

    def parent_comment_notification( comment )
      return unless comment&.parent&.notification_email&.present?

      @reply, @parent = comment_and_parent( comment )

      @user = notified_user( @parent.notification_email, @parent.author_name_or_anon )

      return if @user.do_not_email? # TODO: make this happen without explicit call

      mail to: @user.email_to, subject: parent_comment_notification_subject do |format|
        format.html
        format.text
      end
    end

    def discussion_notification( comment )
      return unless comment&.discussion&.notification_email&.present?

      @comment, @resource, @user = comment_and_resource_and_user( comment )

      return if @user.do_not_email? # TODO: make this happen without explicit call

      mail to: @user.email_to, subject: discussion_notification_subject do |format|
        format.html
        format.text
      end
    end

    def overview_notification( comment )
      email = Setting.get :all_comment_notifications_email
      return if comment.blank? || email.blank?

      @comment = comment

      @user = notified_user( email, 'Admin' )

      mail to: @user.email_to, subject: overview_notification_subject do |format|
        format.html
        format.text
      end
    end

    private

    def parent_comment_notification_subject
      I18n.t(
        'shinycms.discussion_mailer.parent_comment_notification.subject',
        reply_author_name: @reply.author_name_or_anon,
        site_name:         site_name
      )
    end

    def discussion_notification_subject
      I18n.t(
        'shinycms.discussion_mailer.discussion_notification.subject',
        comment_author_name: @comment.author_name_or_anon,
        content_type:        @resource.class.translated_name,
        site_name:           site_name
      )
    end

    def overview_notification_subject
      I18n.t(
        'shinycms.discussion_mailer.overview_notification.subject',
        comment_author_name: @comment.author_name_or_anon,
        site_name:           site_name
      )
    end

    def comment_and_parent( comment )
      [ comment, comment.parent ]
    end

    def comment_and_resource_and_user( comment )
      [ comment, comment.discussion.resource, comment.discussion.resource.user ]
    end

    def check_feature_flags
      enforce_feature_flags :comment_notifications
    end
  end
end
