# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL ( version 2 or later )

# Rails generator for ShinyCMS plugins

# Usage:
#   rails g shiny:plugin plugins/ShinyThings

# This is a modified version of the standard Rails Engine generator, with:
# * Anything that seemed irrelevant removed
# * A bunch of supporting code moved into separate files
# * Some stuff in the templates to tie the resulting plugin into ShinyCMS

require_relative './plugin_generator_base'

module Shiny
  module Generators
    class PluginGenerator < PluginGeneratorBase # :nodoc:
      alias plugin_path app_path

      def initialize( *args )
        @dummy_path = nil
        super
      end

      def create_root_files
        build :gemfile unless options[ :skip_gemfile ]
        build :gemspec unless options[ :skip_gemspec ]
        build :license
        build :rakefile
        build :readme
      end

      def create_app_files
        build :app
      end

      def create_config_files
        build :config
      end

      def create_lib_files
        build :lib
      end

      def create_bin_files
        build :bin
      end

      def finish_template
        build :leftovers
      end

      def self.banner
        'rails g shiny:plugin plugins/ShinyThings'
      end

      private

      def engine?
        options[:mountable]
      end

      def skip_git?
        options[:skip_git]
      end

      def with_dummy_app?
        options[:skip_test].blank? || options[:dummy_path] != 'test/dummy'
      end

      def wrap_in_modules( unwrapped_code )
        unwrapped_code = unwrapped_code.to_s.strip.gsub( /\s$\n/, '' )
        modules.reverse.reduce( unwrapped_code ) do |content, mod|
          str = +"module #{mod}\n"
          str << content.lines.collect { |line| "  #{line}" }.join
          str << ( content.present? ? "\nend" : 'end' )
        end
      end

      def application_definition
        @application_definition ||=
          begin
            dummy_application_path = File.expand_path( "#{dummy_path}/config/application.rb", destination_root )
            unless options[:pretend] || !File.exist?( dummy_application_path )
              contents = File.read( dummy_application_path )
              contents[ ( contents.index( /module (\w+)\n(.*)class Application/m ) ).. ]
            end
          end
      end
      alias store_application_definition! application_definition

      # rubocop:disable Naming/AccessorMethodName
      def get_builder_class
        defined?( ::PluginBuilder ) ? ::PluginBuilder : Rails::PluginBuilder
      end
      # rubocop:enable Naming/AccessorMethodName

      def rakefile_test_tasks
        <<~RUBY
          require 'rake/testtask'

          Rake::TestTask.new( :test ) do |t|
            t.libs << 'test'
            t.pattern = 'test/**/*_test.rb'
            t.verbose = false
          end
        RUBY
      end

      def dummy_path( path = nil )
        @dummy_path = path if path
        @dummy_path || options[:dummy_path]
      end

      def rails_app_path
        APP_PATH.sub( '/config/application', '' ) if defined?( APP_PATH )
      end

      def inside_application?
        rails_app_path && destination_root.start_with?( rails_app_path.to_s )
      end

      def relative_path
        return unless inside_application?

        app_path.sub( /^#{rails_app_path}\//, '' )
      end
    end
  end
end
