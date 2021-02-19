# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for vote features on a ShinyCMS site
  class VotesController < MainController
    include ShinyVotesHelper

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
      type = class_from_votable_url params[ :type ]
      return head( :bad_request ) unless votable_model_names.include? type

      @resource = type.constantize.find( params[ :id ] )
      return head( :not_found ) if @resource.blank?
    end

    def votable_model_names
      [ core_votable_models + plugin_votable_models ].flatten.collect( &:name )
    end

    def core_votable_models
      ShinyCMS::ApplicationRecord.descendants.select( &:votable? )
    end

    def plugin_votable_models
      Plugins.votable_models
    end

    def find_voter
      @voter = current_user if user_signed_in?
      return if @voter.present?

      votable_ip = VotableIP.find_or_create_by!( ip_address: request.ip )
      return if @resource.voted_on_by?( votable_ip ) && Setting.not_true?( :anon_votes_can_change )

      @voter = votable_ip
    end
  end
end
