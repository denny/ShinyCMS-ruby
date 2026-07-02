# frozen_string_literal: true

# ShinyForms plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyForms
  # Mailers for generic form handlers provided by ShinyForms plugin for ShinyCMS
  class FormMailer < ApplicationMailer
    before_action { @to = params[:to] || default_email }

    before_action { @form_name = params[:form_name] }
    before_action { @form_data = params[:form_data] }

    default from: -> { default_email }

    def plain_email
      mail to: @to, subject: email_subject, &:text
    end

    def html_email( template_file: )
      return unless Form.template_file_exists?( template_file )

      mail to: @to, subject: email_subject, template_name: template_file do |format|
        format.html
        format.text
      end
    end

    private

    def email_subject
      form_data_subject = @form_data[:subject] || nil

      return "[#{site_name}] #{form_data_subject}" if form_data_subject.present?

      I18n.t( 'shiny_forms.mailers.form_mailer.default_subject', site_name: site_name )
    end

    def check_feature_flags
      enforce_feature_flags :shiny_forms_emails
    end

    def check_ok_to_email
      # Not really necessary currently, as the existing form handlers only
      # send email to site admins anyway - but that could change in future
      enforce_do_not_contact @to
    end
  end
end
