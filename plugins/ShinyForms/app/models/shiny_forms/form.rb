# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  # Model for forms, from ShinyForms plugin for ShinyCMS
  class Form < ApplicationRecord
    include ShinyDemoDataProvider
    include ShinyName
    include ShinyPaging
    include ShinySlug
    include ShinySoftDelete

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

      filenames = Dir.glob '*.mjml', base: theme_template_dir
      template_names = filenames.map { |filename| filename.remove( '.html.mjml' ) }
      template_names.sort
    end

    def self.default_templates
      filenames = Dir.glob '*.mjml', base: default_template_dir
      template_names = filenames.map { |filename| template_names << filename.remove( '.html.mjml' ) }
      template_names.sort
    end

    def self.theme_template_dir
      Theme.current.template_dir( 'shiny_forms/form_mailer' ) if Theme.current.present?
    end

    def self.default_template_dir
      Rails.root.join 'plugins/ShinyForms/app/views/shiny_forms/form_mailer'
    end

    # Add another validation here, because it uses the class methods above
    validates :filename, inclusion: {
      in: Form.available_templates,
      message: I18n.t( 'shiny_forms.models.forms.template_file_must_exist' ),
      allow_nil: true
    }
  end
end
