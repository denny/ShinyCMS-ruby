# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

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

  def models_with_demo_data
    base_model.descendants.select { |model| model.respond_to?( :dump_for_demo? ) }
  end

  def models_that_are_taggable
    base_model.descendants.select( &:taggable? )
  end

  def models_that_are_votable
    base_model.descendants.select( &:votable? )
  end

  def view_path
    return unless File.exist? Rails.root.join( "plugins/#{name}/app/views/" )

    "plugins/#{name}/app/views/#{name.underscore}"
  end

  def template_exists?( template_path )
    File.exist? "#{view_path}/#{template_path}"
  end

  def admin_index_path( area = nil )
    path_part = area || name.underscore.sub( 'shiny_', '' )

    engine.routes.url_helpers.public_send( "#{path_part}_path" )
  end

  # Class methods

  # Returns an array of the currently enabled plugins
  def self.loaded
    return @loaded if @loaded

    loaded_plugins = loaded_names.collect { |name| Plugin.new( name ) }
    @loaded = loaded_plugins
  end

  def self.loaded?( plugin_name )
    loaded_names.include? plugin_name
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

  def self.with_template( template_path )
    with_views.select { |plugin| plugin.template_exists?( template_path ) }
  end

  def self.models_with_demo_data
    # Used by the rake task that dumps the demo site data
    # Returns names rather than objects to allow the rake task to bodge the dump order
    with_models.collect( &:models_with_demo_data ).flatten.collect( &:name ).sort
  end

  def self.models_that_are_taggable
    with_models.collect( &:models_that_are_taggable ).flatten.sort_by( &:name )
  end

  def self.models_that_are_votable
    with_models.collect( &:models_that_are_votable ).flatten.sort_by( &:name )
  end

  def self.loaded_names
    configured_names || all_names
  end

  def self.configured_names
    ENV[ 'SHINYCMS_PLUGINS' ]&.split( /[, ]+/ )
  end

  def self.all_names
    Dir[ 'plugins/*' ].sort.collect { |plugin_name| plugin_name.sub( 'plugins/', '' ) }
  end
end
