# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  # Mailers for generic form handlers provided by ShinyForms plugin for ShinyCMS
  class FormMailer < ApplicationMailer
    before_action :check_feature_flags

    def plain( to, form_name, form_data )
      email_to = build_to( to )
      return if email_to.blank?

      set_form_data( form_name, form_data )

      mail to: email_to, subject: email_subject, &:text
    end

    def with_template( to, form_name, form_data, filename )
      email_to = build_to( to )
      return if email_to.blank?
      return unless Form.template_file_exists?( filename )

      set_form_data( form_name, form_data )

      mail to: email_to, subject: email_subject, template_name: filename do |format|
        format.html
        format.text
      end
    end

    private

    def build_to( form_handler_email_to )
      form_handler_email_to || Setting.get( :default_email )
    end

    def email_subject
      form_data_subject = @form_data['subject'] || nil

      return "[#{site_name}] #{form_data_subject}" if form_data_subject.present?

      I18n.t( 'shiny_forms.mailers.form_mailer.default_subject', site_name: site_name )
    end

    def set_form_data( form_name, form_data )
      @form_name = form_name
      @form_data = form_data
    end

    def check_feature_flags
      enforce_feature_flags :shiny_forms_emails
    end
  end
end
