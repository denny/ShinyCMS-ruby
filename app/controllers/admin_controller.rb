# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/admin_controller.rb
# Purpose:   Base controller for ShinyCMS admin area
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class AdminController < ApplicationController
  include Pundit
  include AdminAreaHelper

  before_action :check_admin_ip_list
  before_action :authenticate_user!
  before_action :cache_user_capabilities

  skip_before_action :set_view_paths
  skip_after_action  :track_ahoy_visit

  after_action :verify_authorized

  layout 'admin/layouts/admin_area'

  def index
    skip_authorization
    if current_user.not_admin?
      redirect_to root_path
    elsif user_redirect.present?
      redirect_to user_redirect
    else
      redirect_to path_for( current_user.primary_admin_area )
    end
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

  def user_redirect
    custom = Setting.find_by( name: :post_login_redirect ).value_for current_user
    return custom if custom&.start_with? '/'
  end

  def path_for( area = nil )
    area = :root if area.blank?
    area = :news if area == :news_posts
    area = :admin_site_settings if area == :settings

    public_send "#{area}_path"
  end
end
