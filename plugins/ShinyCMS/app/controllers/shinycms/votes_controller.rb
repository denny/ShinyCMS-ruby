# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for vote features on a ShinyCMS site
  class VotesController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    include ShinyCMS::WithVotes

    before_action :check_feature_flags

    before_action :find_resource
    before_action :find_voter

    def create
      if params[ :flag ] == 'down'
        @resource.downvote_by @voter
      else
        @resource.upvote_by @voter
      end

      redirect_back_or_to @resource.path
    end

    def destroy
      @resource.unvote_by @voter

      redirect_back_or_to @resource.path
    end

    private

    def find_resource
      type = url_param_to_class_name( params[ :type ] )
      return head( :bad_request ) unless votable_model_names.include? type

      @resource = type.constantize.find( params[ :id ] )
      return head( :not_found ) if @resource.blank?
    end

    def votable_model_names
      [
        ShinyCMS::Plugin.get( 'ShinyCMS' ).models_that_include( ShinyCMS::HasVotes ) +
          ShinyCMS.plugins.models_that_include( ShinyCMS::HasVotes )
      ].flatten.collect( &:name )
    end

    def find_voter
      @voter = current_user if user_signed_in?
      return if @voter.present?

      votable_ip = VotableIP.find_or_create_by!( ip_address: request.ip )
      return if @resource.voted_on_by?( votable_ip ) && Setting.not_true?( :anon_votes_can_change )

      @voter = votable_ip
    end

    def check_feature_flags
      enforce_feature_flags :upvotes
    end
  end
end
