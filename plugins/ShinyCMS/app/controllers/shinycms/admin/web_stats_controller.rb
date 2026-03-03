# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for viewing web stats in ShinyCMS admin area
  class Admin::WebStatsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    def index
      authorize Ahoy::Visit

      @pagy, @visits = pagy( recent_visits )

      authorize @visits if @visits.present?
    end

    def search
      authorize Ahoy::Visit

      search_term = params[:q]

      @pagy, @visits = pagy(
        recent_visits.where( 'referrer ilike ?', "%#{search_term}%" )
                     .or( recent_visits.where( 'landing_page ilike ?', "%#{search_term}%" ) )
      )

      authorize @visits if @visits.present?
      render :index
    end

    private

    def recent_visits
      return Ahoy::Visit.order( started_at: :desc ) unless user

      Ahoy::Visit.where( user: user ).order( started_at: :desc )
    end

    def user
      return if params[ :user_id ].blank?

      ShinyCMS::User.find( params[ :user_id ] )
    end
  end
end
