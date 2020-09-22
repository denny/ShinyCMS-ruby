# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Theme model, to group some repeated code
class Theme
  attr_accessor :name

  def initialize( theme_name )
    return unless Theme.base_directory_exists?( theme_name )

    self.name = theme_name
  end

  # Delegations

  delegate :present?, to: :name
  delegate :blank?,   to: :name

  # Instance methods

  def view_path
    Theme.view_path( name )
  end

  def template_dir( more_path = '' )
    Rails.root.join view_path, more_path
  end

  # Class methods

  def self.view_path( theme_name )
    "app/views/themes/#{theme_name}"
  end

  def self.base_directory_exists?( theme_name )
    return false if theme_name.blank?

    FileTest.directory?( Rails.root.join( view_path( theme_name ) ) )
  end

  # Find and return the current theme (if any)
  def self.current( user = nil )
    user_theme( user ) || site_theme || default_theme
  end

  def self.user_theme( user )
    return if user.blank?

    theme_name = Setting.get :theme_name, user
    Theme.new( theme_name ).presence
  end

  def self.site_theme
    theme_name = Setting.get :theme_name
    Theme.new( theme_name ).presence
  end

  def self.default_theme
    Theme.new( env_shinycms_theme ).presence
  end

  def self.env_shinycms_theme
    ENV['SHINYCMS_THEME']
  end
end
