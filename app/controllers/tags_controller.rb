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
