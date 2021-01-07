# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Admin controller for managing consent versions
class Admin::ConsentVersionsController < AdminController
  before_action :stash_consent_version, only: %i[ show edit update destroy ]

  helper_method :pagy_url_for

  def index
    authorize ConsentVersion

    @pagy, @consent_versions = pagy( ConsentVersion.order( updated_at: :desc ), items: items_per_page )

    authorize @consent_versions if @consent_versions.present?
  end

  def search
    authorize ConsentVersion

    search_term = params[:q]

    @pagy, @consent_versions = pagy(
      ConsentVersion.where( 'name ilike ?', "%#{search_term}%" )
                    .or( ConsentVersion.where( 'slug ilike ?', "%#{search_term}%" ) )
                    .order( updated_at: :desc ), items: items_per_page
    )

    authorize @consent_versions if @consent_versions.present?
    render :index
  end

  def show
    authorize @consent_version
  end

  def new
    @consent_version = ConsentVersion.new
    authorize @consent_version
  end

  def create
    @consent_version = ConsentVersion.new( consent_version_params )
    authorize @consent_version

    if @consent_version.save
      redirect_to edit_consent_version_path( @consent_version ), notice: t( '.success' )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :new
    end
  end

  def edit
    authorize @consent_version
  end

  def update
    authorize @consent_version

    if @consent_version.update( consent_version_params )
      redirect_to edit_consent_version_path( @consent_version ), notice: t( '.success' )
    else
      flash.now[ :alert ] = t( '.failure' )
      render action: :edit
    end
  end

  def destroy
    authorize @consent_version

    flash[ :notice ] = t( '.success' ) if @consent_version.destroy

    redirect_to consent_versions_path
  end

  private

  def stash_consent_version
    @consent_version = ConsentVersion.find( params[:id] )
  end

  def consent_version_params
    params.require( :consent_version ).permit( :name, :slug, :display_text, :admin_notes )
  end

  # Override pager link format (to admin/action/page/NN rather than admin/action?page=NN)
  def pagy_url_for( page, _pagy )
    params = request.query_parameters.merge( only_path: true, page: page )
    url_for( params )
  end
end
