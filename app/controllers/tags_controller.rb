# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for tag features on a ShinyCMS-powered site
class TagsController < MainController
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
    @tags = ActsAsTaggableOn::Tag.readonly.all
  end

  def list
    @tags = ActsAsTaggableOn::Tag.readonly.all
  end

  def show
    @tag_name = params[ :tag ]
    @tag = ActsAsTaggableOn::Tag.readonly.find_by( name: @tag_name )
    @tagged_items = {}
    taggable_models.each do |resource|
      @tagged_items[ resource.name ] = resource.readonly.tagged_with( @tag_name )
    end
    @element_types = @tagged_items.keys.sort
  end

  private

  def taggable_models
    [ taggable_models_in_core + Plugin.models_that_are_taggable ].flatten
  end

  def taggable_models_in_core
    ApplicationRecord.descendants.select( &:taggable? )
  end

  def check_feature_flags
    enforce_feature_flags :tags
  end
end
