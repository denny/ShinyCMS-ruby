# frozen_string_literal: true

module ShinyForms
  # Basic form handlers for ShinyCMS
  class FormHandler
    def plain_text_email( email_to, form_data, _ )
      FormMailer.plain_text_email( email_to, form_data ).deliver_now
    end

    def mjml_template_email( email_to, form_data, filename )
      FormMailer.mjml_template_email( email_to, form_data, filename ).deliver_now
    end

    def html_template_email( email_to, form_data, filename ); end
  end
end
