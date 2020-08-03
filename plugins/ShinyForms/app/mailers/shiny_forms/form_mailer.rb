# frozen_string_literal: true

module ShinyForms
  # Mailer for discussion-related emails (reply notifications, etc)
  class FormMailer < ApplicationMailer
    before_action :check_feature_flags

    def plain_text_email( to, form_data )
      email_to = build_to( to )
      return if email_to.blank?

      @form_data = form_data

      track open: false, click: false

      mail to: email_to, subject: email_subject, &:text
    end

    def mjml_template_email( to, form_data, filename )
      email_to = build_to( to )
      return if email_to.blank?

      @form_data = form_data

      track open: false, click: false

      mail to: email_to, subject: email_subject do
        "#{filename}.mjml"
      end
    end

    private

    def build_to( form_handler_email_to )
      form_handler_email_to || Setting.get( :default_email )
    end

    def email_subject
      form_data_subject = @form_data['subject'] || nil

      return "[#{@site_name}] #{form_data_subject}" if form_data_subject.present?

      I18n.t( '.default_subject', site_name: @site_name )
    end

    def check_feature_flags
      enforce_feature_flags :shiny_forms_emails
    end
  end
end
