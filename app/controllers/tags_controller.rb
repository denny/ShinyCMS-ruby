# Controller for tag features
class TagsController < ApplicationController
  before_action :check_feature_flags

  def index
    @tags = ActsAsTaggableOn::Tag.all
  end

  def show
    @tag_name = params[ :tag ]
    @tag = ActsAsTaggableOn::Tag.find_by( name: @tag_name )
    @content_types = tagged_content_types
    @tagged_items = {}
    @content_types.each do |type|
      @tagged_items[ type ] = type.constantize.tagged_with( @tag.name )
      # @tagged_items[ 'BlogPost' ] = BlogPost.tagged_with( @tag.name )
    end
  end

  private

  def tagged_content_types
    %w[ BlogPost ]
  end

  def check_feature_flags
    enforce_feature_flags :tags
  end
end
