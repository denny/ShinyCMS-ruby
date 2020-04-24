# frozen_string_literal: true

# Mailer for discussion-related emails (reply notifications, etc)
class DiscussionMailer < ApplicationMailer
  before_action :check_feature_flags

  def parent_comment_notification( comment )
    return unless comment&.parent&.notification_email&.present?

    @reply  = comment
    @parent = comment.parent

    subject = parent_comment_notification_subject( @reply )

    @user = notified_user( @parent.notification_email, @parent.author_name_any )

    mail to: @parent.notification_email, subject: subject do |format|
      format.html
      format.text
    end
  end

  def discussion_notification( comment )
    return unless comment&.discussion&.notification_email&.present?

    @comment  = comment
    @resource = comment.discussion.resource

    subject = discussion_notification_subject( @comment, @resource )

    @user = comment.discussion.resource.user

    mail to: comment.discussion.notification_email, subject: subject do |format|
      format.html
      format.text
    end
  end

  def overview_notification( comment )
    return if comment.blank?

    @comment = comment

    email = Setting.get :all_comment_notifications_email
    return if email.blank?

    subject = overview_notification_subject( @comment )

    @user = notified_user( email, 'Admin' )

    mail to: email, subject: subject do |format|
      format.html
      format.text
    end
  end

  private

  def parent_comment_notification_subject( reply )
    I18n.t(
      'discussion_mailer.parent_comment_notification.subject',
      reply_author_name: reply.author_name_any,
      site_name: @site_name
    )
  end

  def discussion_notification_subject( comment, resource )
    I18n.t(
      'discussion_mailer.discussion_notification.subject',
      comment_author_name: comment.author_name_any,
      content_type: resource.human_name,
      site_name: @site_name
    )
  end

  def overview_notification_subject( comment )
    I18n.t(
      'discussion_mailer.overview_notification.subject',
      comment_author_name: comment.author_name_any,
      site_name: @site_name
    )
  end

  def check_feature_flags
    enforce_feature_flags :comment_notifications
  end
end
