# frozen_string_literal: true

# Model to provide convenience methods for dealing with ShinyCMS plugins
class Plugin
  attr_accessor :name, :this

  def initialize( name )
    name = Plugin.capability_category_to_plugin_name( name ) if name.start_with? 'shiny_'
    return unless Plugin.all.include? name

    @name = name
    @this = name.constantize
  end

  # Instance methods

  def admin_index_path
    return this::Admin.index_path if this::Admin.respond_to? :index_path

    path_part = name.underscore.sub( 'shiny_', '' )
    this::Engine.routes.url_helpers.public_send( "#{path_part}_path" )
  end

  # Class methods

  def self.all
    Dir[ 'plugins/*' ].sort.map { |plugin_name| plugin_name.sub( 'plugins/', '' ) }
  end

  def self.configured
    ENV[ 'SHINYCMS_PLUGINS' ]&.split( /[, ]+/ )
  end

  def self.loaded
    configured || all
  end

  def self.capability_category_to_plugin_name( capability_category )
    capability_category.to_s.sub( %r{_[a-z]+$}, '' ).classify.pluralize
  end
end
