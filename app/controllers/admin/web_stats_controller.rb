# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for viewing web stats in ShinyCMS admin area
class Admin::WebStatsController < AdminController
  before_action :set_ahoy_user

  def index
    authorize Ahoy::Visit

    visits  = Ahoy::Visit
    visits  = visits.where( user: @ahoy_user  ) if @ahoy_user
    @visits = visits.order( started_at: :desc ).page( page_number ).per( items_per_page )

    authorize @visits if @visits.present?
  end

  def search
    authorize Ahoy::Visit

    q = params[:q]

    visits  = Ahoy::Visit
    visits  = visits.where( user: @ahoy_user ) if @ahoy_user
    @visits = visits.where( 'to ilike ?', "%#{q}%" )
                    .or( visits.where( 'subject ilike ?', "%#{q}%" ) )
                    .order( started_at: :desc )
                    .page( page_number ).per( items_per_page )

    authorize @visits if @visits.present?
    render :index
  end

  private

  def set_ahoy_user
    return if params[:user_id].blank?

    @ahoy_user = User.find( params[:user_id] )
  end
end
