# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for viewing email stats in ShinyCMS admin area
class Admin::EmailStatsController < AdminController
  before_action :set_ahoy_user

  def index
    authorize Ahoy::Message

    messages  = Ahoy::Message
    messages  = messages.where( user: @ahoy_user ) if @ahoy_user
    @messages = messages.order( sent_at: :desc   ).page( page_number ).per( items_per_page )

    authorize @messages if @messages.present?
  end

  def search
    authorize Ahoy::Message

    q = params[:q]

    messages  = Ahoy::Message
    messages  = messages.where( user: @ahoy_user ) if @ahoy_user
    @messages = messages.where( 'email_address ilike ?', "%#{q}%" )
                        .order( started_at: :desc )
                        .page( page_number ).per( items_per_page )

    authorize @messages if @messages.present?
    render :index
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
