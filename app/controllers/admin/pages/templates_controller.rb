# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin/pages/templates_controller.rb
# Purpose:   Controller for page templates in ShinyCMS admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class Admin::Pages::TemplatesController < AdminController
  def index
    authorise PageTemplate

    page_num = params[ :page ] || 1

    @templates = PageTemplate.order( :name ).page( page_num )
    authorise @templates if @templates.present?
  end

  def new
    @template = PageTemplate.new
    authorise @template
  end

  def create
    @template = PageTemplate.new( template_params )
    authorise @template

    if @template.save
      redirect_to edit_page_template_path( @template ), notice: t( '.success' )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit
    @template = PageTemplate.find( params[:id] )
    authorise @template
  end

  def update
    @template = PageTemplate.find( params[:id] )
    authorise @template

    if @template.update( template_params )
      redirect_to edit_page_template_path( @template ), notice: t( '.success' )
    else
      flash.now[ :alert ] = t( '.failure' )
      render :edit
    end
  end

  def destroy
    template = PageTemplate.find( params[:id] )
    authorise template

    flash[ :notice ] = t( '.success' ) if template.destroy
    redirect_to page_templates_path
  rescue ActiveRecord::NotNullViolation, ActiveRecord::RecordNotFound
    skip_authorization
    redirect_to page_templates_path, alert: t( '.failure' )
  end

  private

  def template_params
    params.require( :page_template ).permit(
      :name, :description, :filename, elements_attributes: {}
    )
  end
end
