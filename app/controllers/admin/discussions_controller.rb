# Admin controller for discussions and comments
class Admin::DiscussionsController < AdminController
  before_action :stash_discussion
  before_action :stash_comment, except: %i[ hide unhide lock unlock ]

  def hide
    authorise @discussion
    @discussion.hide
    redirect_to request.referer || discussion_path( @discussion )
  end

  def unhide
    authorise @discussion
    @discussion.unhide
    redirect_to request.referer || discussion_path( @discussion )
  end

  def lock
    authorise @discussion
    @discussion.lock
    redirect_to request.referer || discussion_path( @discussion )
  end

  def unlock
    authorise @discussion
    @discussion.unlock
    redirect_to request.referer || discussion_path( @discussion )
  end

  def hide_comment
    authorise @comment
    @comment.hide
    redirect_to request.referer || discussion_path( @discussion )
  end

  def unhide_comment
    authorise @comment
    @comment.unhide
    redirect_to request.referer || discussion_path( @discussion )
  end

  def lock_comment
    authorise @comment
    @comment.lock
    redirect_to request.referer || discussion_path( @discussion )
  end

  def unlock_comment
    authorise @comment
    @comment.unlock
    redirect_to request.referer || discussion_path( @discussion )
  end

  def delete_comment
    authorise @comment
    @comment.delete
    redirect_to request.referer || discussion_path( @discussion )
  end

  private

  def stash_discussion
    @discussion = Discussion.find( params[ :id ] )
  end

  def stash_comment
    @comment = @discussion.comments.find_by( number: params[ :number ] )
  end
end
