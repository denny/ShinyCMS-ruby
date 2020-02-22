# Mailer for discussion-related emails - reply notifications etc
class DiscussionMailer < ApplicationMailer
  before_action :check_feature_flags
  before_action :set_site_name

  def parent_comment_notification( comment )
    return if comment.blank?
    return if comment.parent.blank?
    return if comment.parent.notification_email.blank?

    @reply  = comment
    @parent = comment.parent

    subject = parent_comment_notification_subject( @reply.author_name_any )

    mail to: @parent.notification_email, subject: subject do |format|
      format.html
      format.text
    end
  end

  def discussion_notification( comment )
    return if comment.blank?
    return if comment.discussion.notification_email.blank?

    @comment = comment
    @resource = comment.discussion.resource

    subject = discussion_notification_subject( @comment, @resource )

    mail to: @resource.notification_email, subject: subject do |format|
      format.html
      format.text
    end
  end

  def overview_notification( comment )
    return if comment.blank?

    email = SiteSetting.get :all_comments_email
    return if email.blank?

    @comment = comment

    subject = overview_notification_subject( @comment.author_name_any )

    mail to: email, subject: subject do |format|
      format.html
      format.text
    end
  end

  private

  def parent_comment_notification_subject( author_name )
    I18n.t(
      'discussion_mailer.parent_comment_notification.subject',
      reply_author_name: author_name,
      site_name: @site_name
    )
  end

  def discussion_notification_subject( comment, resource )
    author_name  = comment.author_name_any
    content_type = resource.class.name.underscore.humanize
    I18n.t(
      'discussion_mailer.discussion_notification.subject',
      reply_author_name: author_name,
      content_type: content_type,
      site_name: @site_name
    )
  end

  def overview_notification_subject( author_name )
    I18n.t(
      'discussion_mailer.overview_notification.subject',
      reply_author_name: author_name,
      site_name: @site_name
    )
  end

  def set_site_name
    @site_name = I18n.t( 'discussion_mailer.site_name' )
  end

  def check_feature_flags
    enforce_feature_flags :comment_notifications
  end
end
