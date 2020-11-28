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
    @tags = visible_tags
    if setting( :tag_view ) == 'list'
      render :list
    else
      render :cloud
    end
  end

  def cloud
    @tags = visible_tags
  end

  def list
    @tags = visible_tags
  end

  def show
    @tag_name = params[ :tag ]
    @tag = ActsAsTaggableOn::Tag.readonly.find_by( name: @tag_name )
    @tagged_items = {}
    taggable_models.each do |resource|
      @tagged_items[ resource.name ] = tagged_items_for resource
    end
    @element_types = @tagged_items.keys.sort
  end

  private

  def visible_tags
    ActsAsTaggableOn::Tagging.select { |tagged| tagged.taggable.show_on_site? }
                             .collect( &:tag )
  end

  def tagged_items_for( resource )
    # Currently everything with tags has a .published scope - but this may not always be the case
    return resource.readonly.published.tagged_with( @tag_name ) if resource.respond_to? :published

    # Everything with tags also includes ShinyShowHide currently - again, subject to change
    # return resource.readonly.visible.tagged_with( @tag_name ) if resource.respond_to? :visible

    # resource.readonly.tagged_with( @tag_name )
  end

  def taggable_models
    [ taggable_models_in_core + ShinyPlugin.models_that_are_taggable ].flatten
  end

  def taggable_models_in_core
    ApplicationRecord.descendants.select( &:taggable? )
  end

  def check_feature_flags
    enforce_feature_flags :tags
  end
end
