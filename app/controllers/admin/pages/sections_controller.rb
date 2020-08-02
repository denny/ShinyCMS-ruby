# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/pages/sections_controller.rb
# Purpose:   Controller for page sections in ShinyCMS admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::Pages::SectionsController < AdminController
  # Redirect to the combined page+section list
  def index
    authorise PageSection
    redirect_to pages_path
  end

  def new
    @section = PageSection.new
    authorise @section
  end

  def create
    @section = PageSection.new( section_params )
    authorise @section

    if @section.save
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @section.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit
    @section = PageSection.find( params[:id] )
    authorise @section
  end

  def update
    @section = PageSection.find( params[:id] )
    authorise @section

    if @section.update( section_params )
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @section.id
    else
      flash.now[ :alert ] = t( '.failure' )
      render :edit
    end
  end

  def destroy
    section = PageSection.find( params[:id] )
    authorise section

    flash[ :notice ] = t( '.success' ) if section.destroy
    redirect_to pages_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    redirect_with_alert pages_path, t( '.failure' )
  end

  private

  def section_params
    params.require( :page_section ).permit(
      :internal_name, :public_name, :slug, :description, :section_id,
      :sort_order, :show_on_site, :show_in_menus
    )
  end
end
