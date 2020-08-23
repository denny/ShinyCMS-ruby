# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for vote features on a ShinyCMS site
class VotesController < MainController
  before_action :find_resource
  before_action :find_voter

  def create
    if params[ :flag ] == 'down'
      @resource.downvote_by @voter
    else
      @resource.upvote_by @voter
    end

    redirect_back fallback_location: @resource.path
  end

  def destroy
    @resource.unvote_by @voter

    redirect_back fallback_location: @resource.path
  end

  private

  def find_resource
    type = params[ :type ].classify
    return head( :bad_request ) unless votable_models.include? type

    @resource = type.constantize.find( params[ :id ] )
    return head( :not_found ) if @resource.blank?
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
