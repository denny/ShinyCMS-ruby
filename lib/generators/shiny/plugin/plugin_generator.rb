# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL ( version 2 or later )

# Rails generator for ShinyCMS plugins ( not quite finished, but it'll get you started )
#
# This is a hacked-about copy of the standard Rails Engine plugin generator
# Some stuff that wasn't relevant has been removed
# Some stuff to tie the resulting plugin into ShinyCMS has been added

require 'rails/generators/rails/app/app_generator'
require 'date'

require_relative './plugin_builder'

module Shiny
  module Generators
    # rubocop:disable Metrics/ClassLength
    class PluginGenerator < ::Rails::Generators::AppBase # :nodoc:
      add_shared_options_for 'plugin'

      alias plugin_path app_path

      def initialize( *args )
        @dummy_path = nil
        super
      end

      public_task :set_default_accessors!
      public_task :create_root

      def create_root_files
        build( :readme )
        build( :rakefile )
        build( :gemspec )   unless options[:skip_gemspec]
        build( :license )
        build( :gemfile )   unless options[:skip_gemfile]
      end

      def create_app_files
        build( :app )
      end

      def create_config_files
        build( :config )
      end

      def create_lib_files
        build( :lib )
      end

      def create_assets_manifest_file
        build( :assets_manifest )
      end

      def create_public_stylesheets_files
        build( :stylesheets )
      end

      def create_bin_files
        build( :bin )
      end

      def finish_template
        build( :leftovers )
      end

      public_task :apply_rails_template

      def name
        @name ||=
          begin
            # same as ActiveSupport::Inflector#underscore except not replacing '-'
            underscored = original_name.dup
            underscored.gsub!( /([A-Z]+)([A-Z][a-z])/, '\1_\2' )
            underscored.gsub!( /([a-z\d])([A-Z])/, '\1_\2' )
            underscored.downcase!

            underscored
          end
      end

      def underscored_name
        @underscored_name ||= original_name.underscore
      end

      def namespaced_name
        @namespaced_name ||= name.tr( '-', '/' )
      end

      def self.banner
        # "rails plugin new #{arguments.collect( &:usage ).join( ' ' )} [options]"
        'rails g shiny:plugin plugins/ShinyThing'
      end

      private

      def create_dummy_app( path = nil )
        dummy_path( path ) if path

        say_status :vendor_app, dummy_path
        mute do
          build( :generate_test_dummy )
          store_application_definition!
          build( :test_dummy_config )
          build( :test_dummy_assets )
          build( :test_dummy_clean )
          # ensure that bin/rails has proper dummy_path
          build( :bin, force: true )
        end
      end

      def engine?
        full? || mountable? || options[:engine]
      end

      def full?
        options[:full]
      end

      def mountable?
        options[:mountable]
      end

      def skip_git?
        options[:skip_git]
      end

      def with_dummy_app?
        options[:skip_test].blank? || options[:dummy_path] != 'test/dummy'
      end

      def api?
        options[:api]
      end

      def original_name
        @original_name ||= File.basename( destination_root )
      end

      def modules
        @modules ||= namespaced_name.camelize.split( '::' )
      end

      def wrap_in_modules( unwrapped_code )
        unwrapped_code = unwrapped_code.to_s.strip.gsub( /\s$\n/, '' )
        modules.reverse.inject( unwrapped_code ) do |content, mod|
          str = +"module #{mod}\n"
          str << content.lines.collect { |line| "  #{line}" }.join
          str << ( content.present? ? "\nend" : 'end' )
        end
      end

      def camelized_modules
        @camelized_modules ||= namespaced_name.camelize
      end

      def humanized
        @humanized ||= original_name.underscore.humanize
      end

      def camelized
        @camelized ||= name.gsub( /\W/, '_' ).squeeze( '_' ).camelize
      end

      def author
        default = 'TODO: Write your name'
        if skip_git?
          @author = default
        else
          @author = `git config user.name`.chomp rescue default
        end
      end

      def email
        default = 'TODO: Write your email address'
        if skip_git?
          @email = default
        else
          @email = `git config user.email`.chomp rescue default
        end
      end

      def valid_const?
        return raise_invalid_characters_error      if invalid_characters?
        return raise_numeric_start_error           if numeric_start?
        return raise_numeric_namespace_start_error if numeric_namespace_start?
        return raise_reserved_name_error           if reserved_name?
        return raise_constant_already_in_use_error if constant_already_in_use?
      end

      def reserved_name?
        RESERVED_NAMES.include?( name )
      end

      def invalid_characters?
        /[^\w-]+/.match?( original_name )
      end

      def numeric_start?
        /^\d/.match?( original_name )
      end

      def numeric_namespace_start?
        /-\d/.match?( original_name )
      end

      def constant_already_in_use?
        Object.const_defined?( camelized )
      end

      def raise_invalid_characters_error
        raise Error, "Invalid plugin name '#{original_name}' - name can only contain letters, numbers, '_' and '-'."
      end

      def raise_numeric_start_error
        raise Error, "Invalid plugin name '#{original_name}' - name cannot start with a number."
      end

      def raise_numeric_namespace_start_error
        raise Error, "Invalid plugin name '#{original_name}' - name cannot contain a namespace starting with numbers."
      end

      def raise_reserved_name_error
        raise Error, "Invalid plugin name - '#{original_name}' is in the Rails reserved words list: " \
          "#{RESERVED_NAMES.join( ', ' )}"
      end

      def raise_constant_already_in_use_error
        raise Error, "Invalid plugin name '#{original_name}' - constant #{camelized} is already in use."
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

      def mute( &block )
        shell.mute( &block )
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
    # rubocop:enable Metrics/ClassLength
  end
end
