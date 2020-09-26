# frozen_string_literal: true

# ShinyLists plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyLists
  # Controller for mailing list admin features - part of the ShinyLists plugin for ShinyCMS
  class Admin::ListsController < AdminController
    def index
      authorize List

      page_num = params[ :page ] || 1
      @lists = List.page( page_num )

      authorize @lists if @lists.present?
    end

    def new
      @list = List.new
      authorize @list
    end

    def create
      @list = List.new( list_params )
      authorize @list

      if @list.save
        redirect_to edit_list_path( @list ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :new
      end
    end

    def edit
      @list = List.find( params[:id] )
      authorize @list
    end

    def update
      @list = List.find( params[:id] )
      authorize @list

      if @list.update( list_params )
        redirect_to edit_list_path( @list ), notice: t( '.success' )
      else
        flash.now[ :alert ] = t( '.failure' )
        render action: :edit
      end
    end

    def destroy
      list = List.find( params[:id] )
      authorize list

      flash[ :notice ] = t( '.success' ) if list.destroy
      redirect_to lists_path
    end

    private

    def list_params
      params.require( :list ).permit(
        :internal_name, :public_name, :slug, :description
      )
    end
  end
end
