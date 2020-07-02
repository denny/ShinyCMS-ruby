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
  before_action :find_resource
  before_action :find_voter

  def create
    return unless @resource && @voter

    if params[ :flag ] == 'down'
      @resource.downvote_by @voter
    else
      @resource.upvote_by @voter
    end

    redirect_back fallback_location: @resource.path
  end

  def destroy
    return unless @resource && @voter

    @resource.unvote_by @voter

    redirect_back fallback_location: @resource.path
  end

  private

  def find_resource
    type = params[ :type ].capitalize
    # 400 unless votable_models.include? type
    return unless votable_models.include? type

    @resource = type.constantize.find( params[ :id ] )
    # 404 unless @resource.present?
  end

  def votable_models
    Rails.application.eager_load! if Rails.env.development?
    ApplicationRecord.descendants.select( &:votable? ).map( &:to_s )
  end

  def find_voter
    @voter = current_user if user_signed_in?
    return if @voter.present?

    votable_ip = VotableIP.find_or_create_by!( ip_address: request.ip )
    return if @resource.voted_on_by?( votable_ip ) && anon_votes_are_fixed?

    @voter = votable_ip
  end

  def anon_votes_are_fixed?
    Setting.get( 'anon_votes_are_fixed' )&.downcase == 'yes'
  end
end
