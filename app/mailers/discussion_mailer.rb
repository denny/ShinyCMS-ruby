# Mailer for discussion-related emails - reply notifications etc
class DiscussionMailer < ApplicationMailer
  before_action :check_feature_flags

  def reply_to_comment( comment )
    return if comment.blank?
    return if comment.parent.blank?
    return if comment.parent.notification_email.blank?

    @reply  = comment
    @parent = comment.parent
    subject = reply_to_comment_subject( @reply.author_name_any )

    mail to: @parent.notification_email, subject: subject do |format|
      format.html
      format.text
    end
  end

  private

  def reply_to_comment_subject( author_name )
    site_name = I18n.t( 'discussion_mailer.reply_to_comment.site_name' )
    I18n.t(
      'discussion_mailer.reply_to_comment.subject',
      reply_author_name: author_name,
      site_name: site_name
    )
  end

  def check_feature_flags
    enforce_feature_flags :comment_notifications
  end
end
