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
  def index
    @visits = filtered_visits
    authorise @visits
  end

  def filtered_visits
    page_num = params[ :page ] || 1
    visits = Ahoy::Visit
    if params[:user_id].present?
      @user = User.find( params[:user_id] )
      visits = visits.where( user: @user )
    end
    @visits = visits.order( 'started_at desc' ).page( page_num )
    authorise @visits
  end
end
