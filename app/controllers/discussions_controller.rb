# Main site controller for discussions and comments
class DiscussionsController < ApplicationController
  before_action :check_feature_flags

  def index
    # TODO: list of recently active discussions etc
    redirect_to root_path
  end

  def show
    @discussion = Discussion.find( params[ :id ] )
  end

  def show_thread
    @discussion = Discussion.find( params[ :id ] )
    @comment = @discussion.comments.find_by( number: params[ :number ] )
  end

  private

  def check_feature_flags
    enforce_feature_flags :comments
  end
end
