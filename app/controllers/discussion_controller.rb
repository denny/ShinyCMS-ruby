# Main site controller for blogs (view blog, view blog post, etc)
class DiscussionController < ApplicationController
  before_action :check_feature_flags

  def index
    # Shouldn't be here
    redirect_to root_path
  end

  def show
    @discussion = Discussion.find( params[ :id ] )
  end

  private

  def check_feature_flags
    enforce_feature_flags :comments
  end
end
