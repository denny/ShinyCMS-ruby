# frozen_string_literal: true

module ShinyForms
  # Basic form handlers for ShinyCMS
  class FormHandler
    def plain_text_email( form, form_data ); end

    def mjml_template_email( form, form_data ); end

    def html_template_email( form, form_data ); end
  end
end
