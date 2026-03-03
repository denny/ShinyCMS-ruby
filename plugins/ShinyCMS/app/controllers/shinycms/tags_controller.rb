# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for tag features on a ShinyCMS-powered site
  class TagsController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    before_action :check_feature_flags

    def index
      @tags = visible_tags
      if Setting.get( :tag_view ) == 'list'
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
      ActsAsTaggableOn::Tagging.where( context: 'tags' ).collect( &:tag ).uniq
    end

    def tagged_items_for( resource )
      resource.readonly.tagged_with( @tag_name, on: :tags )
    end

    def taggable_models
      [ main_app_taggable_models + ShinyCMS.plugins.taggable_models ].flatten
    end

    def main_app_taggable_models
      ApplicationRecord.descendants.select( &:taggable? )
    end

    def check_feature_flags
      enforce_feature_flags :tags
    end
  end
end
