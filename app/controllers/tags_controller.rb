# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/tags_controller.rb
# Purpose:   Controller for tag features on a ShinyCMS-powered site
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class TagsController < MainController
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
    Rails.application.eager_load! if Rails.env.development?

    [ taggable_models_in_core + taggable_models_in_plugins ].flatten
  end

  def taggable_models_in_core
    ApplicationRecord.descendants.select( &:taggable? )
  end

  def taggable_models_in_plugins
    taggable_plugin_models = []
    Plugin.with_models.each do |plugin|
      taggable_plugin_models << plugin.base_model.descendants.select( &:taggable? )
    end
    taggable_plugin_models
  end

  def check_feature_flags
    enforce_feature_flags :tags
  end
end
