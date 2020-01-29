# Controller for tag features
class TagsController < ApplicationController
  before_action :check_feature_flags

  def index
    @tags = BlogPost.tag_counts_on( :tags )
  end

  def show
    @tag = params[ :tag ]
    @posts = BlogPost.tagged_with( @tag )
  end

  private

  def check_feature_flags
    enforce_feature_flags :tags
  end
end
