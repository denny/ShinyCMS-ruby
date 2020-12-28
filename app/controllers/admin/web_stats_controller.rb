# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for viewing web stats in ShinyCMS admin area
class Admin::WebStatsController < AdminController
  helper_method :pagy_url_for

  def index
    authorize Ahoy::Visit

    visits = ahoy_visits
    visits = visits_by_user if params[ :user_id ]

    @pagy, @visits = pagy( visits, items: items_per_page )

    authorize @visits if @visits.present?
  end

  def search
    authorize Ahoy::Visit

    q = params[:q]

    @pagy, @visits = pagy(
      Ahoy::Visit.where( 'referrer ilike ?', "%#{q}%" )
                 .or( Ahoy::Visit.where( 'landing_page ilike ?', "%#{q}%" ) )
                 .order( started_at: :desc ), items: items_per_page
    )

    authorize @visits if @visits.present?
    render :index
  end

  private

  def ahoy_visits
    Ahoy::Visit.order( started_at: :desc )
  end

  def visits_by_user
    ahoy_visits.where( user: user )
  end

  def user
    User.find( params[ :user_id ] )
  end

  # Override pager link format (to admin/action/page/NN rather than admin/action?page=NN)
  def pagy_url_for( page, _pagy )
    params = request.query_parameters.merge( only_path: true, page: page )
    url_for( params )
  end
end
