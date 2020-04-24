# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/web_stats_controller.rb
# Purpose:   Controller for viewing web stats in ShinyCMS admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::WebStatsController < AdminController
  before_action :set_ahoy_user

  def index
    authorise Ahoy::Visit

    page_num = params[ :page ] || 1
    visits = Ahoy::Visit
    visits = visits.where( user: @ahoy_user ) if @ahoy_user
    @visits = visits.order( 'started_at desc' ).page( page_num )

    authorise @visits if @visits.present?
  end

  private

  def set_ahoy_user
    return if params[:user_id].blank?

    @ahoy_user = User.find( params[:user_id] )
  end
end
