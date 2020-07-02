# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/votes_controller.rb
# Purpose:   Controller for vote features on a ShinyCMS site
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class VotesController < ApplicationController
  def create
    resource = find_resource
    voter = find_voter

    if resource && voter
      if params[ :flag ] == 'down'
        resource.downvote_by voter
      else
        resource.upvote_by voter
      end
    end

    redirect_back fallback_location: resource.path
  end

  def destroy
    resource = find_resource
    voter = find_voter

    resource.unvote_by voter if resource && voter

    redirect_back fallback_location: resource.path
  end

  private

  def find_resource
    type = params[ :type ].capitalize
    return unless votable_models.include? type

    type.constantize.find( params[ :id ] )
  end

  def find_voter
    current_user
  end

  def votable_models
    Rails.application.eager_load! if Rails.env.development?
    ApplicationRecord.descendants.select( &:votable? ).map( &:to_s )
  end
end
