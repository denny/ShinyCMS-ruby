# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Theme model, to group some repeated code
  class Theme
    attr_reader :name

    def initialize( theme_name )
      @name = theme_name if Theme.files_exist?( theme_name )
    end

    # Get the current theme (if any)
    def self.get( user = nil )
      return unless database_exists?

      user_theme( user ) || site_theme || default_theme
    end

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
      "themes/#{theme_name}/views"
    end

    def self.files_exist?( theme_name )
      return false if theme_name.blank?

      Rails.root.join( "themes/#{theme_name}" ).directory?
    end

    def self.template_dir( more_path = '' )
      theme = get
      return if theme.blank?

      theme.template_dir( more_path )
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
      ENV.fetch( 'SHINYCMS_THEME', nil )
    end

    def self.database_exists?
      ActiveRecord::Base.connection.active?
    rescue ActiveRecord::NoDatabaseError
      # :nocov:
      false
      # :nocov:
    end
  end
end
