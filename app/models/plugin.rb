# frozen_string_literal: true

# Model to provide convenience methods for dealing with ShinyCMS plugins
class Plugin
  attr_accessor :name

  def initialize( name )
    name = Plugin.capability_category_to_plugin_name( name ) if name.to_s.start_with? 'shiny_'
    return unless Plugin.all_names.include? name

    @name = name
  end

  # Instance methods

  def engine
    @engine ||= name.constantize::Engine
  end

  def base_model
    @base_model ||= name.constantize::ApplicationRecord
  end

  def template_exists?( template_path )
    File.exist? Rails.root.join "plugins/#{name}/app/views/#{name.underscore}/#{template_path}"
  end

  def admin_index_path( controller_name = nil )
    path_part = controller_name || name
    path_part = path_part.underscore.sub( 'shiny_', '' )

    engine.routes.url_helpers.public_send( "#{path_part}_path" )
  end

  # Class methods

  # Returns a hash of the currently enabled plugins keyed by their camel-cased name
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

  def self.base_models
    base_models = []
    loaded.each do |plugin|
      base_models << plugin.base_model
    end
    base_models
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

  def self.capability_category_to_plugin_name( capability_category )
    capability_category.to_s.sub( %r{_[a-z]+$}, '' ).classify.pluralize
  end
end
