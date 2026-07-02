# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Controller for access control group admin features - part of the ShinyAccess plugin for ShinyCMS
  class Admin::GroupsController < ApplicationController
    include ShinyCMS::AdminAreaControllerBase

    before_action :stash_query, only: :search
    before_action :stash_group, only: %i[ edit update destroy ]

    def index
      authorize Group
      @pagy, @groups = pagy( groups )
      authorize @groups if @groups.present?
    end

    def search
      authorize Group

      @pagy, @groups = pagy( groups.admin_search( @query ) )

      authorize @groups if @groups.present?
      render :index
    end

    def new
      @group = Group.new
      authorize @group
    end

    def create
      @group = Group.new( strong_params )
      authorize @group

      if @group.save
        redirect_to edit_group_path( @group ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      authorize @group
    end

    def update
      authorize @group

      if @group.update( strong_params )
        redirect_to edit_group_path( @group ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      authorize @group

      flash[ :notice ] = t( '.success' ) if @group.destroy
      redirect_to groups_path
    end

    private

    def groups
      Group.order( :internal_name )
    end

    def stash_group
      @group = Group.find( params[:id] )
    end

    def stash_query
      params.permit( :q )
      @query = params[ :q ]
    end

    def strong_params
      params.expect( group: %i[ internal_name public_name slug description ] )
    end
  end
end
