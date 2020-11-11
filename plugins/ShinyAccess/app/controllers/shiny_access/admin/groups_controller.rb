# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Controller for access control group admin features - part of the ShinyAccess plugin for ShinyCMS
  class Admin::GroupsController < AdminController
    def index
      authorize Group

      page_num = params[ :page ] || 1
      @groups = Group.page( page_num )

      authorize @groups if @groups.present?
    end

    def search
      authorize Group

      q = params[:q]
      @groups = Group.where( 'internal_name ilike ?', "%#{q}%" )
                     .or( Group.where( 'slug ilike ?', "%#{q}%" ) )
                     .order( :internal_name )
                     .page( page_number ).per( items_per_page )

      authorize @groups if @groups.present?
      render :index
    end

    def new
      @group = Group.new
      authorize @group
    end

    def create
      @group = Group.new( group_params )
      authorize @group

      if @group.save
        redirect_to edit_group_path( @group ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @group = Group.find( params[:id] )
      authorize @group
    end

    def update
      @group = Group.find( params[:id] )
      authorize @group

      if @group.update( group_params )
        redirect_to edit_group_path( @group ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      group = Group.find( params[:id] )
      authorize group

      flash[ :notice ] = t( '.success' ) if group.destroy
      redirect_to groups_path
    end

    private

    def group_params
      params.require( :group ).permit(
        :internal_name, :public_name, :slug, :description
      )
    end
  end
end
