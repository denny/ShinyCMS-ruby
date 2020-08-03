# frozen_string_literal: true

module ShinyForms
  # Mailer for discussion-related emails (reply notifications, etc)
  class FormMailer < ApplicationMailer
    before_action :check_feature_flags

    def plain_text_email( form, form_data )
      email_to = email_to( form )
      return if email_to.blank?

      subject = subject_line( form_data.subject )

      track open: false, click: false

      mail to: email_to( form ), subject: subject, &:text
    end

    def mjml_template_email( form, form_data )
      email_to = email_to( form )
      return if email_to.blank?

      subject = subject_line( form_data.subject )

      track open: false, click: false

      mail to: email_to, subject: subject, &:mjml
    end

    private

    def email_to( form )
      form.email_to || Setting.get( :default_email )
    end

    def subject_line( form_subject )
      return "[#{@site_name}] #{form_subject}" if form_subject.present?

      I18n.t( '.default_subject', site_name: @site_name )
    end

    def check_feature_flags
      enforce_feature_flags :shiny_forms_emails
    end
  end
end
