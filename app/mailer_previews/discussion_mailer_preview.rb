# frozen_string_literal: true

# Rails Email Preview controller for previewing Discussion-related emails
class DiscussionMailerPreview
  def parent_comment_notification
    DiscussionMailer.parent_comment_notification fetch_comment
  end

  def discussion_notification
    DiscussionMailer.discussion_notification fetch_comment
  end

  def overview_notification
    DiscussionMailer.overview_notification fetch_comment
  end

  private

  def fetch_comment
    @comment_id ? Comment.find( @comment_id ) : mock_comment
  end

  def mock_comment
    comments = Comment.where( hidden: false, spam: false )
    comments.not( parent: nil ).last || comments.last
  end
end
