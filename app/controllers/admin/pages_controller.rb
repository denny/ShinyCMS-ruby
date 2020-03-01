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
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @page.id
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
      flash[ :notice ] = t( '.success' )
      redirect_to action: :edit, id: @page.id
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
    redirect_with_alert pages_path, t( '.failure' )
  end

  private

  def page_params
    params.require( :page ).permit(
      :name, :description, :title, :slug, :template_id, :section_id,
      :sort_order, :hidden, :hidden_from_menu,
      elements_attributes: {}
    )
  end
end
