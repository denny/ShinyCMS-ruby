# Main site controller for discussions and comments
class DiscussionsController < ApplicationController
  before_action :check_feature_flags
  before_action :stash_discussion, except: :index
  before_action :stash_comment, except: %i[ index show add_comment ]

  def index
    # TODO: list of recently active discussions etc
    redirect_to root_path
  end

  def show; end

  def show_thread; end

  def add_comment
    @parent = @discussion
    save_comment
  end

  def add_reply
    @parent = @comment
    save_comment
  end

  def save_comment
    comment = @parent.comments.new(
      comment_params.merge( discussion: @discussion )
    )

    if comment.save
      flash[ :notice ] = t( '.success' )
      redirect_to action: :show
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :show
    end
  end

  private

  def stash_discussion
    @discussion = Discussion.find( params[ :id ] )
  end

  def stash_comment
    @comment = @discussion.comments.find_by( number: params[ :number ] )
  end

  def comment_params
    params.require( :comment ).permit( :title, :body )
  end

  def check_feature_flags
    enforce_feature_flags :comments
  end
end
