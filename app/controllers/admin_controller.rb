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

  skip_before_action :set_view_paths
  skip_after_action  :track_ahoy_visit

  after_action :verify_authorized

  layout 'admin/layouts/admin_area'

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def index
    skip_authorization
    redirect_to root_path unless current_user.can? :view_admin_area

    # If user has set a post_login_redirect, use it here
    custom = Setting.find_by( name: :post_login_redirect ).value_for current_user
    if custom.present? && custom.start_with?('/')
      redirect_to custom
    # Otherwise, redirect based on which admin features they have access to
    # (in approximate order of most 'useful' ones first)
    elsif current_user.can? :list, :pages
      redirect_to pages_path
    elsif current_user.can? :list, :blogs
      redirect_to blogs_path
    elsif current_user.can? :list, :news_posts
      redirect_to news_path
    elsif current_user.can? :list, :users
      redirect_to users_path
    elsif current_user.can? :list, :settings
      redirect_to admin_site_settings_path
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  private

  # Check whether a list of permitted admin IP addresses has been defined,
  # and if one has, then redirect anybody not coming from one of those IPs.
  def check_admin_ip_list
    allowed = Setting.get :admin_ip_list
    return if allowed.blank?

    return if allowed.strip.split( /\s*,\s*|\s+/ ).include? request.remote_ip

    redirect_to root_path
  end
end
