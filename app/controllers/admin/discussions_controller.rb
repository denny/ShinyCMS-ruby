# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/discussions_controller.rb
# Purpose:   Controller for ShinyCMS comment/discussion admin features
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::DiscussionsController < AdminController
  before_action :stash_discussion

  def show
    authorise @discussion
    @discussion.show
    redirect_to request.referer || discussion_path( @discussion )
  end

  def hide
    authorise @discussion
    @discussion.hide
    redirect_to request.referer || discussion_path( @discussion )
  end

  def lock
    authorise @discussion
    @discussion.lock
    redirect_to request.referer || discussion_path( @discussion )
  end

  def unlock
    authorise @discussion
    @discussion.unlock
    redirect_to request.referer || discussion_path( @discussion )
  end

  private

  def stash_discussion
    @discussion = Discussion.find( params[ :id ] )
  end
end
