# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/email_stats_controller.rb
# Purpose:   Controller for viewing email stats in ShinyCMS admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::EmailStatsController < AdminController
  before_action :set_ahoy_user

  def index
    authorise Ahoy::Message

    page_num = params[ :page ] || 1
    messages = Ahoy::Message
    messages = messages.where( user: @ahoy_user ) if @ahoy_user
    @messages = messages.order( 'sent_at desc' ).page( page_num )

    authorise @messages if @messages.present?
  end

  private

  def set_ahoy_user
    return if params[:user_id].blank?

    @ahoy_user =
      if params[:user_type].presence == 'EmailRecipient'
        EmailRecipient.find( params[:user_id] )
      else
        User.find( params[:user_id] )
      end
  end
end
