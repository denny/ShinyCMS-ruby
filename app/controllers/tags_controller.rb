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
    @tagged_items = {}
    taggable_models.each do |resource|
      @tagged_items[ resource.name ] = resource.tagged_with( @tag_name )
    end
    @content_types = @tagged_items.keys.sort
  end

  private

  def taggable_models
    ApplicationRecord.descendants.select( &:taggable? )
  end

  def check_feature_flags
    enforce_feature_flags :tags
  end
end
