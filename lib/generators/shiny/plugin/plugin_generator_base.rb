# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL ( version 2 or later )

# Supporting methods for ShinyCMS plugin generator

require 'rails/generators/rails/app/app_generator'
require 'date'

require_relative './plugin_builder'

module Shiny
  module Generators
    # rubocop:disable Metrics/ClassLength
    class PluginGeneratorBase < ::Rails::Generators::AppBase # :nodoc:
      add_shared_options_for 'plugin'

      public_task :set_default_accessors!
      public_task :create_root
      public_task :apply_rails_template

      alias plugin_path app_path

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

      def api?
        options[:api]
      end

      def original_name
        @original_name ||= File.basename( destination_root )
      end

      def modules
        @modules ||= namespaced_name.camelize.split( '::' )
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
        if skip_git?
          @author = 'TODO: Write your name'
        else
          @author =
            begin
              `git config user.name`.chomp
            rescue StandardError
              'TODO: Write your name'
            end
        end
      end

      def email
        if skip_git?
          @email = 'TODO: Write your email address'
        else
          @email =
            begin
              `git config user.email`.chomp
            rescue StandardError
              'TODO: Write your email address'
            end
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
