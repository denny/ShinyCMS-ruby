# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Admin controller for newsletter sends - part of ShinyNewsletters plugin for ShinyCMS
  class Admin::SendsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    include ShinyCMS::Admin::WithDateTimeInputs

    include ShinyLists::Admin::WithLists

    helper_method :recently_updated_lists

    before_action :stash_send, only: %i[ show edit update destroy start_sending cancel_sending ]
    before_action :stash_send_for_create, only: %i[ create ]
    before_action :stash_sending_and_scheduled, only: %i[ index ]

    def index
      authorize Send

      @pagy, @sends = pagy( Send.unscheduled.with_editions )

      authorize @sends     if @sends.present?
      authorize @sending   if @sending.present?
      authorize @scheduled if @scheduled.present?
    end

    def sent
      authorize Send

      @pagy, @sent = pagy( Send.sent.with_editions )

      authorize @sent if @sent.present?
    end

    def search
      authorize Send

      @pagy, @sends = pagy( Send.admin_search( params[:q] ) )

      authorize @sends if @sends.present?
      render :index
    end

    def show
      authorize @send
    end

    def new
      @send = Send.new( edition_id: params[:edition_id].presence )
      authorize @send
    end

    def create
      authorize @send

      if @send.save
        redirect_to shiny_newsletters.edit_send_path( @send ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      authorize @send
    end

    def update
      authorize @send

      if @send.update( strong_params )
        redirect_to shiny_newsletters.edit_send_path( @send ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    def start_sending
      authorize @send

      @send.update!( send_at: Time.zone.now ) if @send.scheduled?

      flash[ :notice ] = t( '.success' ) if @send.start_sending

      redirect_to shiny_newsletters.sends_path
    end

    def cancel_sending
      authorize @send

      flash[ :notice ] = t( '.success' ) if @send.cancel_sending

      redirect_to shiny_newsletters.sends_path
    end

    def destroy
      authorize @send

      flash[ :notice ] = t( '.success' ) if @send.destroy

      redirect_to shiny_newsletters.sends_path
    end

    private

    def stash_send
      @send = Send.find( params[:id] )
    end

    def stash_send_for_create
      @send = Send.new( strong_params )
    end

    def stash_sending_and_scheduled
      @sending   = Send.sending.with_editions
      @scheduled = Send.scheduled.with_editions if viewing_first_page?
    end

    def strong_params
      return if params[ :send ].blank?

      temp_params = params.expect( send: %i[ edition_id list_id send_at send_at_time send_now ] )

      combine_date_and_time_params( temp_params, :send_at )
    end

    def viewing_first_page?
      ( params[:page] || 1 ) == 1
    end
  end
end
