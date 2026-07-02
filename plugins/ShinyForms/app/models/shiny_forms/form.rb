# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  # Model for forms, from ShinyForms plugin for ShinyCMS
  class Form < ApplicationRecord
    include ShinyCMS::HasPublicName
    include ShinyCMS::HasSlug
    include ShinyCMS::SoftDelete

    include ShinyCMS::ProvidesDemoSiteData

    # Validations

    validates :slug, uniqueness: true

    # Instance methods

    def action
      "/form/#{slug}"
    end

    def send_to_handler( form_data )
      return false_after_logging_warning unless handler_exists?

      handlers.public_send( handler.to_sym, self, form_data )
    end

    def false_after_logging_warning
      Rails.logger.warn "Unknown form handler '#{handler}' (form ID: #{id})"
      false
    end

    def handler_exists?
      return false unless ShinyForms::FormHandler::FORM_HANDLERS.include? handler

      handlers.respond_to?( handler.to_sym )
    end

    def handlers
      @handlers ||= FormHandler.new
    end

    # Class methods

    def self.template_file_exists?( filename )
      Form.available_templates.include? filename
    end

    # Get a list of available template files from the disk
    def self.available_templates
      ( theme_templates + default_templates ).uniq.sort
    end

    def self.theme_templates
      return [] unless theme_template_dir

      filenames = Dir.glob "*#{file_extension}", base: theme_template_dir
      template_names( filenames )
    end

    def self.default_templates
      filenames = Dir.glob "*#{file_extension}", base: default_template_dir
      template_names( filenames )
    end

    def self.template_names( filenames )
      filenames.collect { |filename| filename.remove( file_extension ) }
    end

    def self.theme_template_dir
      ShinyCMS::Theme.get&.template_dir 'shiny_forms/form_mailer'
    end

    def self.default_template_dir
      ShinyForms::Engine.root.join 'app/views/shiny_forms/form_mailer'
    end

    def self.admin_search( search_term )
      where( 'internal_name ilike ?', "%#{search_term}%" )
        .or( where( 'slug ilike ?', "%#{search_term}%" ) )
        .order( :internal_name )
    end

    def self.file_extension
      '.html.mjml'
    end

    # Add another validation here, because it uses the class methods above
    validates :filename, inclusion: {
      in:        Form.available_templates,
      message:   I18n.t( 'shiny_forms.models.forms.template_file_must_exist' ),
      allow_nil: true
    }
  end
end
