# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/pages_controller.rb
# Purpose:   Controller for pages section of ShinyCMS admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::PagesController < AdminController
  def index
    authorise Page
    authorise PageSection
    @top_level_items = Page.all_top_level_items
    @top_level_items.each do |item|
      authorise item
    end
  end

  def new
    @page = Page.new
    authorise @page
  end

  def create
    @page = Page.new( page_params )
    authorise @page

    if @page.save
      redirect_to edit_page_path( @page ), notice: t( '.success' )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit
    @page = Page.find( params[:id] )
    authorise @page
  end

  def update
    @page = Page.find( params[:id] )
    authorise @page

    if @page.update( page_params )
      redirect_to edit_page_path( @page ), notice: t( '.success' )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def destroy
    page = Page.find( params[:id] )
    authorise page

    flash[ :notice ] = t( '.success' ) if page.destroy
    redirect_to pages_path
  rescue ActiveRecord::RecordNotFound, ActiveRecord::NotNullViolation
    skip_authorization
    redirect_to pages_path, alert: t( '.failure' )
  end

  private

  def page_params
    params.require( :page ).permit(
      :internal_name, :public_name, :slug, :description, :template_id, :section_id,
      :sort_order, :show_on_site, :show_in_menus,
      elements_attributes: {}
    )
  end
end
