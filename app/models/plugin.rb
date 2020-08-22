# frozen_string_literal: true

# Model to provide convenience methods for dealing with ShinyCMS plugins
class Plugin
  attr_accessor :name

  def initialize( name )
    return unless Plugin.all_names.include? name

    @name = name
  end

  # Instance methods

  def engine
    @engine ||= name.constantize::Engine
  end

  def base_model
    @base_model ||= name.constantize::ApplicationRecord if defined? name.constantize::ApplicationRecord
  end

  def main_site_helper
    @main_site_helper ||= name.constantize::MainSiteHelper if defined? name.constantize::MainSiteHelper
  end

  def template_exists?( template_path )
    File.exist? Rails.root.join "plugins/#{name}/app/views/#{name.underscore}/#{template_path}"
  end

  def view_path
    return unless File.exist? Rails.root.join( "plugins/#{name}/app/views/" )

    "plugins/#{name}/app/views/#{name.underscore}"
  end

  def admin_index_path( area = nil )
    path_part = area || name.underscore.sub( 'shiny_', '' )

    engine.routes.url_helpers.public_send( "#{path_part}_path" )
  end

  # Class methods

  # Returns an array of the currently enabled plugins
  def self.loaded
    return @loaded if @loaded

    loading = []
    loaded_names.each do |name|
      loading << Plugin.new( name )
    end
    @loaded = loading
  end

  def self.with_template( template_path )
    plugins = []
    loaded.each do |plugin|
      plugins << plugin if plugin.template_exists?( template_path )
    end
    plugins
  end

  def self.with_main_site_helpers
    loaded.select( &:main_site_helper )
  end

  def self.with_models
    loaded.select( &:base_model )
  end

  def self.with_views
    loaded.select( &:view_path )
  end

  def self.loaded_names
    configured_names || all_names
  end

  def self.all_names
    Dir[ 'plugins/*' ].sort.map { |plugin_name| plugin_name.sub( 'plugins/', '' ) }
  end

  def self.configured_names
    ENV[ 'SHINYCMS_PLUGINS' ]&.split( /[, ]+/ )
  end
end
