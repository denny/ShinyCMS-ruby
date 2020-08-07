# frozen_string_literal: true

# Model to provide convenience methods for dealing with ShinyCMS plugins
class Plugin
  attr_accessor :name

  def initialize( name )
    return unless Plugin.all.include? name

    @name = name
  end

  # Instance methods

  def index_path
    engine_helpers = name.constantize::Engine.routes.url_helpers
    path_part = name.underscore.sub( 'shiny_', '' )

    if path_part == 'news'
      engine_helpers.public_send( "#{path_part}_index_path" )
    else
      engine_helpers.public_send( "#{path_part}_path" )
    end
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
end
