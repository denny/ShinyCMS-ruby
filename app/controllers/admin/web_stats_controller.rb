# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for viewing web stats in ShinyCMS admin area
class Admin::WebStatsController < AdminController
  helper_method :pagy_url_for

  def index
    authorize Ahoy::Visit

    @pagy, @visits = pagy( recent_visits, items: items_per_page )

    authorize @visits if @visits.present?
  end

  def search
    authorize Ahoy::Visit

    search_term = params[:q]

    @pagy, @visits = pagy(
      recent_visits.where( 'referrer ilike ?', "%#{search_term}%" )
                   .or( recent_visits.where( 'landing_page ilike ?', "%#{search_term}%" ) ),
      items: items_per_page
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

    User.find( params[ :user_id ] )
  end

  # Override pager link format (to admin/action/page/NN rather than admin/action?page=NN)
  def pagy_url_for( page, _pagy )
    # :nocov:
    params = request.query_parameters.merge( only_path: true, page: page )
    url_for( params )
    # :nocov:
  end
end
