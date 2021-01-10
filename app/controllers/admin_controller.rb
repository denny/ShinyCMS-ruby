# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Base controller for the admin area in ShinyCMS
class AdminController < ApplicationController
  include Pundit

  include ShinyPagingHelper

  before_action :check_admin_ip_list
  before_action :authenticate_user!
  before_action :cache_user_capabilities

  after_action :verify_authorized

  layout 'admin/layouts/admin_area'

  helper Rails.application.routes.url_helpers

  helper_method :load_html_editor?
  helper_method :pagy_url_for

  def index
    skip_authorization

    if ShinyPlugin.loaded?( :ShinyPages ) && current_user.can?( :list, :pages )
      redirect_to shiny_pages.pages_path
    else
      redirect_to root_path
    end
  end

  def not_found
    skip_authorization
    bad_path = params[:path]
    redirect_to admin_path, alert: t( 'admin.invalid_url', request_path: bad_path )
  end

  def default_items_per_page
    Setting.get_int( :default_items_per_page_in_admin_area ) || Setting.get_int( :default_items_per_page ) || 10
  end

  private

  # Check whether a list of permitted admin IP addresses has been defined,
  # and if one has, then redirect anybody not coming from one of those IPs.
  def check_admin_ip_list
    allowed = Setting.get :admin_ip_list
    return if allowed.blank?

    return if allowed.strip.split( /\s*,\s*|\s+/ ).include? request.remote_ip

    redirect_to root_path
  end

  def cache_user_capabilities
    current_user&.cache_capabilities
  end

  def load_html_editor?
    false
  end

  # Override pager link format (to admin/action/page/NN rather than admin/action?page=NN)
  def pagy_url_for( page, _pagy )
    params = request.query_parameters.merge( only_path: true, page: page )
    url_for( params )
  end
end
