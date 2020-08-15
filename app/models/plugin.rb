# frozen_string_literal: true

# Model to provide convenience methods for dealing with ShinyCMS plugins
class Plugin
  attr_accessor :name, :this

  def initialize( name )
    name = Plugin.capability_category_to_plugin_name( name ) if name.to_s.start_with? 'shiny_'
    return unless Plugin.all.include? name

    @name = name
    @this = name.constantize
  end

  # Instance methods

  def admin_index_path( controller_name = nil )
    path_part = controller_name || name
    path_part = path_part.underscore.sub( 'shiny_', '' )

    # FIXME
    return ShinyBlogs::Engine.routes.url_helpers.blogs_path if path_part == 'blogs'
    return ShinyBlogs::Engine.routes.url_helpers.blog_posts_path( ShinyBlogs::Blog.first ) if path_part == 'posts'

    path_part = 'news_posts' if path_part == 'news'

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

  def self.base_records
    return @base_records if @base_records

    @base_records = []
    loaded.each do |plugin|
      base_records << plugin.constantize::ApplicationRecord
    end
    @base_records
  end
end
