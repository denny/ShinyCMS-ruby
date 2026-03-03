# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Main site controller for discussion features - part of the ShinyCMS core plugin
  class DiscussionsController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    include ShinyCMS::WithAkismet
    include ShinyCMS::WithRecaptcha

    before_action :check_feature_flags
    before_action :stash_discussion, except: %i[ index ]

    def index
      count = ( params[ :count ] || 10 ).to_i
      days  = ( params[ :days  ] || 7  ).to_i
      @active_discussions, @recent_comment_counts =
        Discussion.readonly.recently_active( days: days, count: count )
    end

    def show; end

    def show_thread; end

    private

    def stash_discussion
      @discussion = Discussion.readonly.find params[ :id ]
    end

    def check_feature_flags
      enforce_feature_flags :comments
    end
  end
end
