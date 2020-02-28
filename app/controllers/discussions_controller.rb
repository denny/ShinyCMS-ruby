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

  def show_thread
    return if @comment.present?

    @resource_type = 'Comment'
    render 'errors/404', status: :not_found
  end

  def add_comment
    @parent = @discussion
    save_comment
  end

  def add_reply
    @parent = @comment
    save_comment
  end

  def save_comment
    comment = @parent.comments.new( comment_params )

    if comment.save
      flash[ :notice ] = t( '.success' )
      redirect_back fallback_location: discussion_path( @discussion )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :show
    end
  end

  private

  def stash_discussion
    @discussion = Discussion.find( params[ :id ] )
  rescue ActiveRecord::RecordNotFound
    render 'errors/404', status: :not_found
  end

  def stash_comment
    @comment = @discussion.comments.find_by( number: params[ :number ] ) || nil
  end

  def comment_params
    p = params.require( :comment ).permit(
      %i[ title body author_type author_name author_email author_url ]
    )
    p = p.merge( user_id: current_user.id ) if user_signed_in?
    p.merge( discussion_id: @discussion.id )
  end

  def check_feature_flags
    enforce_feature_flags :comments
  end
end
