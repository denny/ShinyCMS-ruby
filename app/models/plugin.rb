# frozen_string_literal: true

# Model to provide convenience methods for dealing with ShinyCMS plugins
class Plugin
  attr_accessor :name

  def initialize( name )
    name = Plugin.snake_to_camel_name( name ) if name.start_with? 'shiny_'
    return unless Plugin.all.include? name

    @name = name
  end

  # Instance methods

  def admin_index_path
    engine = name.constantize::Engine

    return engine.helpers.admin_index_path if engine.helpers.respond_to? :admin_index_path

    path_part = name.underscore.sub( 'shiny_', '' )
    engine.routes.url_helpers.public_send( "#{path_part}_path" )
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

  def self.snake_to_camel_name( snake_name )
    snake_name.to_s.sub( %r{_[a-z]+$}, '' ).classify.pluralize
  end
end
