# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Provides convenience methods for interacting with ShinyCMS plugins
class ShinyPlugin
  attr_reader :name

  def initialize( name )
    return unless ShinyPlugin.all_names.include? name

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

  def models_that_are( method )
    base_model.descendants.select( &method )
  end

  def models_that_respond_to( method )
    base_model.descendants.select { |model| model.respond_to?( method ) }
  end

  def view_path
    return unless File.exist? Rails.root.join( "plugins/#{name}/app/views/" )

    "plugins/#{name}/app/views/#{name.underscore}"
  end

  def template_exists?( template_path )
    File.exist? "#{view_path}/#{template_path}"
  end

  # Class methods

  # Returns an array of the currently enabled plugins
  def self.loaded
    return @loaded if @loaded

    loaded_plugins = loaded_names.collect { |name| ShinyPlugin.new( name ) }
    @loaded = loaded_plugins
  end

  def self.loaded?( plugin_name )
    loaded_names.include? plugin_name.to_s
  end

  def self.taggable_models
    models_that_are :taggable?
  end

  def self.votable_models
    models_that_are :votable?
  end

  def self.models_with_demo_data
    models_that_respond_to :dump_for_demo?
  end

  def self.models_with_sitemap_items
    models_that_respond_to :sitemap_items
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

  def self.models_that_are( method )
    with_models.collect { |plugin| plugin.models_that_are method }.flatten.sort_by( &:name )
  end

  def self.models_that_respond_to( method )
    with_models.collect { |plugin| plugin.models_that_respond_to method }.flatten.sort_by( &:name )
  end

  def self.loaded_names
    configured_names || all_names
  end

  def self.configured_names
    requested = ENV[ 'SHINYCMS_PLUGINS' ]&.split( /[, ]+/ )

    return requested.uniq.select { |name| all_names.include?( name ) } if requested.present?
  end

  def self.all_names
    Dir[ 'plugins/*' ].collect { |plugin_name| plugin_name.sub( 'plugins/', '' ) }
  end
end
