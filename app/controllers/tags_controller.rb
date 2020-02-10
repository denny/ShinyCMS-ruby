# Controller for tag features
class TagsController < ApplicationController
  include MainSiteHelper

  before_action :check_feature_flags

  def index
    @tags = ActsAsTaggableOn::Tag.all
    if setting( :tag_view ) == 'list'
      render :list
    else
      render :cloud
    end
  end

  def cloud
    @tags = ActsAsTaggableOn::Tag.all
  end

  def list
    @tags = ActsAsTaggableOn::Tag.all
  end

  def show
    @tag_name = params[ :tag ]
    @tag = ActsAsTaggableOn::Tag.find_by( name: @tag_name )
    @content_types = tagged_content_types
    @tagged_items = {}
    @content_types.each do |type|
      @tagged_items[ type ] = type.constantize.tagged_with( @tag.name )
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
