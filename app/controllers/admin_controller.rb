# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Base controller for the admin area in ShinyCMS
class AdminController < ApplicationController
  include Pundit
  include AdminAreaHelper

  before_action :check_admin_ip_list
  before_action :authenticate_user!
  before_action :cache_user_capabilities

  after_action :verify_authorized

  layout 'admin/layouts/admin_area'

  helper_method :load_html_editor?

  def index
    skip_authorization
    if current_user.not_admin?
      redirect_to root_path
    elsif user_redirect.present?
      redirect_to user_redirect
    else
      redirect_to primary_admin_path
    end
  end

  def not_found
    skip_authorization
    bad_path = params[:path]
    redirect_to admin_path, alert: t( 'admin.invalid_url', request_path: bad_path )
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

  # Return the 'most useful' admin path that a user has access to
  # FIXME: this is horrible :D and totally ignores separation of plugins
  def primary_admin_path
    return unless current_user.admin?

    return primary_admin_path_web_content if primary_admin_path_web_content
    return primary_admin_path_email       if primary_admin_path_email
    return primary_admin_path_stats       if primary_admin_path_stats

    return main_app.users_path if current_user.can? :list, :users
  end

  def primary_admin_path_web_content
    return shiny_pages.pages_path     if current_user.can? :list, :pages
    return shiny_blog.blog_posts_path if current_user.can? :list, :blog_posts
    return shiny_news.news_posts_path if current_user.can? :list, :news_posts
    return main_app.comments_path     if current_user.can? :list, :spam_comments
  end

  def primary_admin_path_email
    return shiny_newsletters.editions_path if current_user.can? :list, :newsletter_editions
    return shiny_lists.lists_path          if current_user.can? :list, :mailing_lists
  end

  def primary_admin_path_stats
    return main_app.web_stats_path    if current_user.can? :view_web,   :stats
    return main_app.email_stats_path  if current_user.can? :view_email, :stats
  end

  def load_html_editor?
    false
  end
end
