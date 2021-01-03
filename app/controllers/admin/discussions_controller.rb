# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for ShinyCMS comment/discussion admin features
class Admin::DiscussionsController < AdminController
  before_action :stash_discussion

  def show
    authorize @discussion
    @discussion.show
    redirect_to request.referer || discussion_path( @discussion )
  end

  def hide
    authorize @discussion
    @discussion.hide
    redirect_to request.referer || discussion_path( @discussion )
  end

  def lock
    authorize @discussion
    @discussion.lock
    redirect_to request.referer || discussion_path( @discussion )
  end

  def unlock
    authorize @discussion
    @discussion.unlock
    redirect_to request.referer || discussion_path( @discussion )
  end

  private

  def stash_discussion
    @discussion = Discussion.find( params[ :id ] )
  end
end
